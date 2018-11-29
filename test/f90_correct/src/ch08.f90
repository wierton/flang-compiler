! Copyright (c) 1999, NVIDIA CORPORATION.  All rights reserved.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
!
! character pointer as dummy argument

subroutine sub1(tst,l)
 implicit none
 integer :: l
 character(l), pointer :: tst(:)
 allocate(tst(1:2))
 tst(1) = 'abc'
 tst(2) = 'def'
end subroutine

subroutine sub2(tst)
 implicit none
 character(*), pointer :: tst(:)
 allocate(tst(1:2))
 tst(1) = 'ghi'
 tst(2) = 'jkl'
end subroutine

module mod
contains
 subroutine mub1(tst,l)
  implicit none
  integer l
  character(l), pointer :: tst(:)
  allocate(tst(1:2))
  tst(1) = 'mno'
  tst(2) = 'pqr'
 end subroutine

 subroutine mub2(tst)
  implicit none
  character(*), pointer :: tst(:)
  allocate(tst(1:2))
  tst(1) = 'stu'
  tst(2) = 'vwx'
 end subroutine
end module

program p
 use mod
 interface
  subroutine sub1(tst,l)
   integer :: l
   character(l), pointer :: tst(:)
  end subroutine
  subroutine sub2(tst)
   character(*), pointer :: tst(:)
  end subroutine
 end interface

 character*(3),dimension(:),pointer :: s1,s2,m1,m2
 integer expect(8),result(8)
 data expect/8*1/

 call sub1(s1,3)
 call sub2(s2)
 call mub1(m1,3)
 call mub2(m2)

 !print *,s1,s2,m1,m2
 result = 0
 if( s1(1) .eq. 'abc' ) result(1) = 1
 if( s1(2) .eq. 'def' ) result(2) = 1
 if( s2(1) .eq. 'ghi' ) result(3) = 1
 if( s2(2) .eq. 'jkl' ) result(4) = 1
 if( m1(1) .eq. 'mno' ) result(5) = 1
 if( m1(2) .eq. 'pqr' ) result(6) = 1
 if( m2(1) .eq. 'stu' ) result(7) = 1
 if( m2(2) .eq. 'vwx' ) result(8) = 1
 call check(result,expect,8)
end program
