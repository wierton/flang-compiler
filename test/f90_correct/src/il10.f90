!** Copyright (c) 2003, NVIDIA CORPORATION.  All rights reserved.
!**
!** Licensed under the Apache License, Version 2.0 (the "License");
!** you may not use this file except in compliance with the License.
!** You may obtain a copy of the License at
!**
!**     http://www.apache.org/licenses/LICENSE-2.0
!**
!** Unless required by applicable law or agreed to in writing, software
!** distributed under the License is distributed on an "AS IS" BASIS,
!** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!** See the License for the specific language governing permissions and
!** limitations under the License.
!
! FS task 857
! 'ss' gets inlined into 'tt'
! the optional argument 'b' is passed as the null-value from the
! common block pghpf_0_
! This gets loaded into an integer register, then used in mulsd
!
! We really need to be able to test the 'present' function call after inlining
!
! compile with pgf90 -Minline -fast
!
module m
 real(8), dimension(10) :: rres

contains
 subroutine ss( a, b )
   real(8), dimension(:) :: a
   real(8), optional :: b
   a = 2*a
   if( present(b) )then
     a = a+b
   endif
 end subroutine
 subroutine res( a )
  real(8),dimension(:) :: a
  rres(1:10) = rres(1:10) + a(1:10)
 end subroutine
end module

subroutine tt
  use m
  real(8) x(10), y
  x = (/ 1,2,3,4,5,6,7,8,9,10 /)
  call ss(x)
  call res(x)
end

subroutine uu
  use m
  real(8) x(10), y
  y = 10.0
  x = (/ 1,2,3,4,5,6,7,8,9,10 /)
  call ss(x, y)
  call res(x)
end

subroutine vv
  use m
  real(8) x(10)
  x = (/ 1,2,3,4,5,6,7,8,9,10 /)
  call ss(x, 5.0d0)
  call res(x)
end

program p
 use m
 integer result(10)
 integer expect(10)
 data expect/21,27,33,39,45,51,57,63,69,75/
 rres = 0.0d0
 call tt
 call uu
 call vv
 result = rres
 !print *,result
 call check(result,expect,10)
end
