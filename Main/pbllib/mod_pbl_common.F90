!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
!
!    This file is part of ICTP RegCM.
!
!    ICTP RegCM is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    ICTP RegCM is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with ICTP RegCM.  If not, see <http://www.gnu.org/licenses/>.
!
!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

module mod_pbl_common
!
! Storage parameters and constants related to the boundary layer
!
  use mod_intkinds
  use mod_realkinds
  use mod_constants
  use mod_memutil
  use mod_regcm_types

  implicit none

  private

  real(rkx) , public , pointer , dimension(:,:) :: ricr

  integer(ik4) , pointer , public , dimension(:,:) :: kmxpbl

  !
  ! Pointers to the TCM state variables
  !
  type(tcm_state) , public :: uwstate
  real(rkx) , public , pointer , dimension(:,:,:,:) :: chiuwten

end module mod_pbl_common

! vim: tabstop=8 expandtab shiftwidth=2 softtabstop=2
