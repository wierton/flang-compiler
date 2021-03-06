/*
 * Copyright (c) 2014-2019, NVIDIA CORPORATION.  All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
#include "mthdecls.h"

#if     defined(TARGET_LINUX_POWER)
float
__mth_i_anint(float f)
{
  float x;
  asm("frin %0, %1"
     : "=d"(x)
     : "d"(f)
     :
     );
  return x;
}
#else   /* #if     defined(TARGET_LINUX_POWER) */
float
__mth_i_anint(float f)
{
  double x = f;     /* Cases where f == 0.0 or f == NaN */

  if (f > 0.0)
    (void)modf(f + 0.5f, &x);
  else if (f < 0.0)
    (void)modf(f - 0.5f, &x);
  return x;
}
#endif  /* #if     defined(TARGET_LINUX_POWER) */
