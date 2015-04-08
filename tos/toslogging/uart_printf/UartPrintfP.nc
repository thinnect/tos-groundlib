//#include "printf.h"
#include "logger.h"

int printfflush() { return 1; }


// URDIE vs TXCIE methods for data transfer:
//   Tiny Bluetooth stack for TinyOS
//   Department of Computer Science, University of Copenhagen
//   by Martin Leopolt
//   Spring 2003

#ifdef _H_atmega128hardware_H
	static int uart_putchar(char c, FILE *stream);
	static FILE atm128_stdout =
		FDEV_SETUP_STREAM(TCAST(int (*)(char c, FILE *stream), uart_putchar),
		NULL, _FDEV_SETUP_WRITE);
#endif


module UartPrintfP @safe()
{
	provides interface StdControl @exactlyonce();

	uses interface StdControl    as HplUartTxControl;
	uses interface HplAtm128Uart as HplUart;

	uses interface Leds;
}


implementation
{
	// most significant bit shows if m_dec_errors has ever been > 127.
	// 7 remaining bits is the error counter.
	uint8_t m_errors = 0;
	bool m_module_started = FALSE;

	// ------------------------------------------------------------------
	// Local character queue implementation. copy/paste from BigQueueC.nc with style changes and clippings.
	// Cause of this duplication is that the tinyos queue is not async-safe, and when using the uartqueue_*
	// functions, then there are a lot of false-positive compilation warnings:
	//    warning: `Queue.enqueue' called asynchronously from `uartqueue_*
	// A better way would have been to declare the Queue module as norace (since this module really guarantees
	// that the Queue object is not used parallelly), but norace can only be used for variables.

	uint8_t m_qbuf[PRINTF_BUFFER_SIZE];
	uint16_t m_qhead = 0;
	uint16_t m_qtail = 0;
	uint16_t m_qsize = 0;

	inline bool m_queue_empty() {
		return m_qsize == 0;
	}
	inline uint16_t m_queue_size() {
		return m_qsize;
	}
	inline uint16_t m_queue_max_size() {
		return PRINTF_BUFFER_SIZE;
	}
	inline uint8_t m_queue_head() {
		return m_qbuf[m_qhead];
	}
	uint8_t m_queue_dequeue() {
		uint8_t t = m_queue_head();
		if (!m_queue_empty()) {
			m_qhead++;
			if (m_qhead == PRINTF_BUFFER_SIZE) {
				m_qhead = 0;
			}
			m_qsize--;
		}
		return t;
	}
	error_t m_queue_enqueue(uint8_t newVal) {
		if (m_queue_size() < m_queue_max_size()) {
			m_qbuf[m_qtail] = newVal;
			m_qtail++;
			if (m_qtail == PRINTF_BUFFER_SIZE) {
				m_qtail = 0;
			}
			m_qsize++;
			return SUCCESS;
		}
		else {
			return FAIL;
		}
	}

	// ------------------------------------------------------------------
	// Misc functions
	//

	// convert 0..15 to hex ascii 0..F
	// input: 11
	// output: 'B'
	static inline uint8_t hexdigit(uint8_t i)
	{
		return i < 0xA ? i + '0' : i - 0xA + 'A';
	}

	// enable interrupt: USART Data Register Empty
	inline void m_enable_UDRE_int()
	{
		#ifdef PRINTF_USING_UART0
			SET_BIT(UCSR0B, UDRIE0);
		#endif
		#ifdef PRINTF_USING_UART1
			SET_BIT(UCSR1B, UDRIE1);
		#endif
	}

	// ------------------------------------------------------------------
	// Public interface
	//

	command error_t StdControl.start()
	{
		call Leds.led1On();

		call HplUartTxControl.start();
		atomic {
			#ifdef _H_atmega128hardware_H
				atomic stdout = &atm128_stdout;
			#endif
			m_module_started = 1;
		}
		return SUCCESS;
	}

	command error_t StdControl.stop()
	{
		atomic m_module_started = 0;
		call HplUartTxControl.stop();
		call Leds.led1Off();
		return SUCCESS;
	}

	// define the function used by stdlib printf to send characters
	#ifdef _H_msp430hardware_h
	int putchar(int c) __attribute__((noinline)) @C() @spontaneous()
	{
	#endif
	#ifdef _H_atmega128hardware_H
	int uart_putchar(char c, FILE *stream) __attribute__((noinline)) @C() @spontaneous()
	{
	#endif
		call Leds.led2Toggle();
		atomic {
			if (m_module_started) {
				// enable interrupt: USART Data Register Empty
				m_enable_UDRE_int();
				if (m_queue_enqueue(c) != SUCCESS) {
					m_errors = (0x80 & m_errors) | (m_errors + 1);
					return -1;
				}
				return 0;
			} else {
				return -1;
			}
		}
	}

	async event void HplUart.rxDone(uint8_t data) { }
	async event void HplUart.txDone() { }

	// ------------------------------------------------------------------
	// Functions for fast logging.
	//
	// The fastest way to fill the uart queue. Use these to completely
	// bypass the char-by-char queue fill of the stdlib.
	//
	// These are visible to other modules as-is. No need to include anything
	//   uartqueue_putstr("hello\n");
	//

	void uartqueue_putstr(const char* s) __attribute__((noinline)) @C() @spontaneous()
	{
		atomic {
			if (m_module_started) {
				m_enable_UDRE_int();
				while (*s) {
					m_queue_enqueue(*s++);
				}
			}
		}
	}

	void uartqueue_putbuf(uint8_t* buf, uint8_t len) __attribute__((noinline)) @C() @spontaneous()
	{
		atomic {
			if (m_module_started) {
				m_enable_UDRE_int();
				while (len--) {
					m_queue_enqueue(*buf++);
				}
			}
		}
	}

	void uartqueue_putbufhex(uint8_t* buf, uint8_t len) __attribute__((noinline)) @C() @spontaneous()
	{
		atomic {
			if (m_module_started) {
				uint8_t i = 0;
				m_enable_UDRE_int();
				while (len--) {
					uint8_t c = *buf++;
					m_queue_enqueue(hexdigit(c >> 4));
					m_queue_enqueue(hexdigit(c & 0x0F));
					if (++i == 4) {
						i = 0;
						m_queue_enqueue(' ');
					}
				}
			}
		}
	}

	// ------------------------------------------------------------------
	// UART interrupt handlers
	//

	#ifdef PRINTF_USING_UART0
		AVR_ATOMIC_HANDLER(USART0_UDRE_vect)
		{
			if (m_queue_empty()) {
				// disable interrupt: USART Data Register Empty
				CLR_BIT(UCSR0B, UDRIE0);
			} else {
				UDR0 = m_queue_dequeue();
			}
		}
	#endif

	#ifdef PRINTF_USING_UART1
		AVR_ATOMIC_HANDLER(USART1_UDRE_vect)
		{
			if (m_queue_empty()) {
				// disable interrupt: USART Data Register Empty
				CLR_BIT(UCSR1B, UDRIE1);
			} else {
				UDR1 = m_queue_dequeue();
			}
		}
	#endif
}
