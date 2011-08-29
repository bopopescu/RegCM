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

module mod_rad_common

  use mod_constants
  use mod_dynparam
  use mod_memutil

  public

  logical :: lchem ! ichem logical equiv
  integer :: chmixtyp ! mixtype
  real(8) :: ptp ! ptop
  real(8) , pointer , dimension(:) :: flev , hlev ! sigma , a
  real(8) , pointer , dimension(:,:) :: sfps    ! sps2%ps
  real(8) , pointer , dimension(:,:) :: psfps   ! sps1%ps

  real(8) , pointer , dimension(:,:,:) :: tatms  ! atms%tb3d
  real(8) , pointer , dimension(:,:,:) :: qvatms ! atms%qvb3d
  real(8) , pointer , dimension(:,:,:) :: rhatms ! atms%rhb3d
  real(8) , pointer , dimension(:,:) :: tground ! sfsta%tgbb
  real(8) , pointer , dimension(:,:) :: xlat ! mddom%xlat

  real(8) , pointer , dimension(:) :: abveg   ! sabveg
  real(8) , pointer , dimension(:) :: solar   ! solis
  real(8) , pointer , dimension(:) :: soldir  ! solvs
  real(8) , pointer , dimension(:) :: soldif  ! solvd
  real(8) , pointer , dimension(:) :: coszen  ! coszrs
  real(8) , pointer , dimension(:) :: swdiralb ! aldirs
  real(8) , pointer , dimension(:) :: swdifalb ! aldifs
  real(8) , pointer , dimension(:) :: lwdiralb ! aldirl
  real(8) , pointer , dimension(:) :: lwdifalb ! aldifl
  real(8) , pointer , dimension(:) :: diralb  ! albdir
  real(8) , pointer , dimension(:) :: difalb  ! albdif
  real(8) , pointer , dimension(:) :: swalb   ! albvs
  real(8) , pointer , dimension(:) :: lwalb   ! albvl
  real(8) , pointer , dimension(:) :: emsvt   ! emiss
  real(8) , pointer , dimension(:,:) :: abveg2d ! sabv2d
  real(8) , pointer , dimension(:,:) :: solar2d ! sol2d
  real(8) , pointer , dimension(:,:) :: totsol2d ! sinc2d
  real(8) , pointer , dimension(:,:) :: soldir2d ! solvs2d
  real(8) , pointer , dimension(:,:) :: soldif2d ! solvd2d
  real(8) , pointer , dimension(:,:) :: solswdir ! sols2d
  real(8) , pointer , dimension(:,:) :: sollwdir ! soll2d
  real(8) , pointer , dimension(:,:) :: solswdif ! solsd2d
  real(8) , pointer , dimension(:,:) :: sollwdif ! solld2d
  real(8) , pointer , dimension(:,:) :: srfabswflx ! fsw2d
  real(8) , pointer , dimension(:,:) :: srflwflxup ! flw2d
  real(8) , pointer , dimension(:,:) :: srflwflxdw ! flwd2d
  integer , pointer , dimension(:,:,:) :: lndocnicemsk ! ocld2d

  real(8) , pointer , dimension(:,:,:,:) :: chspmix  ! chia

  real(4) , pointer , dimension(:,:,:,:,:,:) :: chdextmix ! dextmix
  real(4) , pointer , dimension(:,:,:,:,:,:) :: chdssamix ! dssamix
  real(4) , pointer , dimension(:,:,:,:,:,:) :: chdgmix   ! dgmix

  character(len=5) , pointer , dimension(:) :: tracname ! chtrname

  integer :: ncld ! # of bottom model levels with no clouds

  real(8) , pointer , dimension(:,:) :: cldfra , cldlwc
  real(8) , pointer , dimension(:,:,:) :: heatrt
  real(8) , pointer , dimension(:,:,:) :: o3prof

  integer :: idirect , iemiss
  logical :: doabsems , dolw , dosw
  integer :: ichso4 , ichbc , ichoc

  real(8) :: chfrovrradfr ! chfrq/rafrq

  integer(8) :: ntabem

  data lchem /.false./

  contains 

  subroutine allocate_mod_rad_common
    implicit none
    call getmem2d(cldfra,1,iym1,1,kz,'mod_rad:cldfra')
    call getmem2d(cldlwc,1,iym1,1,kz,'mod_rad:cldlwc')
    call getmem3d(heatrt,1,iym1,1,kz,1,jxp,'mod_rad:heatrt')
    call getmem3d(o3prof,1,iym1,1,kzp1,1,jxp,'mod_rad:o3prof')
  end subroutine  allocate_mod_rad_common

end module mod_rad_common
