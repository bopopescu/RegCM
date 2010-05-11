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
!
      module mod_postproc_param
      implicit none
!
! PARAMETER definitions
!
      real(4) :: dtbc
      real(4) :: dtout
      real(4) :: dtbat
      real(4) :: dtrad
      real(4) :: dtche
      real(4) :: dtsub

      integer :: nhrbc
      integer :: nhrout
      integer :: nhrbat
      integer :: nhrsub
      integer :: nhrrad
      integer :: nhrche

      integer , parameter :: npl = 11
      integer , parameter :: nfmax = 999

      real(4) , dimension(npl) :: plev
      real(4) , dimension(npl) :: plevr

      data    plev/1000.,925.,850.,700.,500.,400.,300.,250.,200.,       &
            &      150.,100./
      data    plevr/100.,150.,200.,250.,300.,400.,500.,700.,850.,       &
            &       925., 1000./

      character(70) , parameter :: plist = 'postproc.in'
      character(70) , parameter :: ulist = 'user.in'

      end module mod_postproc_param
