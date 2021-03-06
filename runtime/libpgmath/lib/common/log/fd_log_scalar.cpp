
/*
 * Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
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

#include <immintrin.h>
#include <common.h>


#if !(defined _CPU)
#error: please define _CPU - specific suffix to a function name
#endif

#define _JOIN2(a,b) a##b
#define JOIN2(a,b) _JOIN2(a,b)

#define log_d_scalar JOIN2(__fd_log_1_,_CPU)
#define FMA __builtin_fma

extern "C" double log_d_scalar(double);


static double __attribute__ ((always_inline)) __log_d_scalar_kernel(double m, double e)
{
    m = m - 1.0;

    double m2 = m * m;
    double m4 = m2 * m2;
    double m5 = m4 * m;
    double m8 = m4 * m4;

    double t0 = FMA(c0[0], m, c1[0]);
    double t1 = FMA(c2[0], m, c3[0]);
    double t2 = FMA(c4[0], m, c5[0]);
    double t3 = FMA(c6[0], m, c7[0]);
    double t4 = FMA(c8[0], m, c9[0]);
    double t5 = FMA(c10[0], m, c11[0]);
    double t6 = FMA(c12[0], m, c13[0]);
    double t7 = FMA(c14[0], m, c15[0]);

    double t = c16[0];
    t = FMA(t, m, c17[0]);
    t = FMA(t, m, c18[0]);
    t = FMA(t, m2, m);
    t = FMA(e, LOG_2[0], t);

    t0 = FMA(t0, m2, t1);
    t2 = FMA(t2, m2, t3);
    t4 = FMA(t4, m2, t5);
    t6 = FMA(t6, m2, t7);
    t0 = FMA(t0, m4, t2);
    t4 = FMA(t4, m4, t6);
    t0 = FMA(t0, m8, t4);

    t = FMA(t0, m5, t);

    return t;
}

double __attribute__ ((noinline)) log_d_scalar(double a_input)
{
    __m128d va, vm, ve, vb;
    double a, m, e, b, t;
    long long  mu, eu;


#ifdef __AVX512F__
    va = _mm_set_sd(a_input);
    vm = _mm_getmant_sd(va, va, _MM_MANT_NORM_p75_1p5, _MM_MANT_SIGN_nan);
    ve = _mm_getexp_sd(va, va);
    vb = _mm_getexp_sd(vm, vm);
    ve = _mm_sub_sd(ve, vb);
    m = _mm_cvtsd_f64(vm);
    e = _mm_cvtsd_f64(ve);
#else
    int exp_offset = 1023;
    unsigned long long u = double_as_ll(a_input);
    u -= 0x10000000000000LL;
    if (__builtin_expect(u >= 0x7fe0000000000000LL, 0)) {
        if (a_input != a_input) return a_input + a_input; // NaN
        if (a_input < 0.0) return ll_as_double(CANONICAL_NAN[0]); // negative
        if (a_input == 0.0) return ll_as_double(NINF[0]); // zero
        if (double_as_ll(a_input) == PINF[0]) return ll_as_double(PINF[0]); // +infinity
        a_input *= TWO_TO_53; // denormals
        exp_offset += 53;
        mu = double_as_ll(a_input);
        mu -= double_as_ll(THRESHOLD[0]);
        eu = (mu >> 52) - 53;
        mu &= MANTISSA_MASK[0];
        mu += double_as_ll(THRESHOLD[0]);
        m = ll_as_double(mu);
        e = (double)eu;
        return __log_d_scalar_kernel(m, e);
    }
    mu = double_as_ll(a_input);
    mu -= double_as_ll(THRESHOLD[0]);
    eu = mu >> 52;
    mu &= MANTISSA_MASK[0];
    mu += double_as_ll(THRESHOLD[0]);
    m = ll_as_double(mu);
    e = (double)eu;
#endif

    return __log_d_scalar_kernel(m, e);
}

