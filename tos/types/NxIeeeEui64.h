/**
 * Struct for IEEE EUI64 with network byte order and nx_structs.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#ifndef NXIEEEEUI64_H
#define NXIEEEEUI64_H

#include "IeeeEui64.h"

typedef nx_struct nx_ieee_eui64 {
  nx_uint8_t data[IEEE_EUI64_LENGTH];
} nx_ieee_eui64_t;

#endif // NXIEEEEUI64_H
