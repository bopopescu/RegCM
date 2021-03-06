#include <misc.h>
#include <preproc.h>

!-----------------------------------------------------------------------
!BOP
!
! !IROUTINE: CNiniSpecial
!
! !INTERFACE:
subroutine CNiniSpecial ()
!
! !DESCRIPTION:
! One-time initialization of CN variables for special landunits
!
! !USES:
   use shr_kind_mod, only: r8 => shr_kind_r8
   use pftvarcon   , only: noveg
   use decompMod   , only: get_proc_bounds
   use clm_varcon  , only: spval
   use clmtype
   use CNSetValueMod
!
! !ARGUMENTS:
   implicit none
!
! !CALLED FROM:
! subroutine iniTimeConst in file iniTimeConst.F90
!
! !REVISION HISTORY:
! 11/13/03: Created by Peter Thornton
!
!EOP
!
! local pointers to implicit in arguments
!
  integer , pointer :: clandunit(:)    ! landunit index of corresponding column
  integer , pointer :: plandunit(:)    ! landunit index of corresponding pft
  logical , pointer :: ifspecial(:)    ! BOOL: true=>landunit is wetland,ice,lake, or urban
!
! local pointers to implicit out arguments
!
! !LOCAL VARIABLES:
   integer :: fc,fp,l,c,p  ! indices
   integer :: begp, endp   ! per-clump/proc beginning and ending pft indices
   integer :: begc, endc   ! per-clump/proc beginning and ending column indices
   integer :: begl, endl   ! per-clump/proc beginning and ending landunit indices
   integer :: begg, endg   ! per-clump/proc gridcell ending gridcell indices
   integer :: num_specialc ! number of good values in specialc filter
   integer :: num_specialp ! number of good values in specialp filter
   integer, allocatable :: specialc(:) ! special landunit filter - columns
   integer, allocatable :: specialp(:) ! special landunit filter - pfts
!-----------------------------------------------------------------------
   ! assign local pointers at the landunit level
   ifspecial => clm3%g%l%ifspecial

   ! assign local pointers at the column level
   clandunit => clm3%g%l%c%landunit

   ! assign local pointers at the pft level
   plandunit => clm3%g%l%c%p%landunit

   ! Determine subgrid bounds on this processor
   call get_proc_bounds(begg, endg, begl, endl, begc, endc, begp, endp)

   ! allocate special landunit filters
   allocate(specialc(endc-begc+1))
   allocate(specialp(endp-begp+1))

   ! fill special landunit filters
   num_specialc = 0
   do c = begc, endc
      l = clandunit(c)
      if (ifspecial(l)) then
         num_specialc = num_specialc + 1
         specialc(num_specialc) = c
      end if
   end do

   num_specialp = 0
   do p = begp, endp
      l = plandunit(p)
      if (ifspecial(l)) then
         num_specialp = num_specialp + 1
         specialp(num_specialp) = p
      end if
   end do

   ! initialize column-level fields
   call CNSetCps(num_specialc, specialc, spval, clm3%g%l%c%cps)
   call CNSetCcs(num_specialc, specialc, 0._r8, clm3%g%l%c%ccs)
   call CNSetCns(num_specialc, specialc, 0._r8, clm3%g%l%c%cns)
   call CNSetCcf(num_specialc, specialc, 0._r8, clm3%g%l%c%ccf)
   call CNSetCnf(num_specialc, specialc, 0._r8, clm3%g%l%c%cnf)
   ! 4/14/05: PET
   ! adding isotope code
   call CNSetCcs(num_specialc, specialc, 0._r8, clm3%g%l%c%cc13s)
   call CNSetCcf(num_specialc, specialc, 0._r8, clm3%g%l%c%cc13f)
   

   ! initialize column-average pft fields
   call CNSetPps(num_specialc, specialc, spval, clm3%g%l%c%cps%pps_a)
   call CNSetPcs(num_specialc, specialc, 0._r8, clm3%g%l%c%ccs%pcs_a)
   call CNSetPns(num_specialc, specialc, 0._r8, clm3%g%l%c%cns%pns_a)
   call CNSetPcf(num_specialc, specialc, 0._r8, clm3%g%l%c%ccf%pcf_a)
   call CNSetPnf(num_specialc, specialc, 0._r8, clm3%g%l%c%cnf%pnf_a)

   ! initialize pft-level fields
   call CNSetPepv(num_specialp, specialp, spval, clm3%g%l%c%p%pepv)
   call CNSetPps(num_specialp, specialp, spval, clm3%g%l%c%p%pps)
   call CNSetPcs(num_specialp, specialp, 0._r8, clm3%g%l%c%p%pcs)
   call CNSetPns(num_specialp, specialp, 0._r8, clm3%g%l%c%p%pns)
   call CNSetPcf(num_specialp, specialp, 0._r8, clm3%g%l%c%p%pcf)
   call CNSetPnf(num_specialp, specialp, 0._r8, clm3%g%l%c%p%pnf)
   ! 4/14/05: PET
   ! adding isotope code
   call CNSetPcs(num_specialp, specialp, 0._r8, clm3%g%l%c%p%pc13s)
   call CNSetPcf(num_specialp, specialp, 0._r8, clm3%g%l%c%p%pc13f)

   ! now loop through special filters and explicitly set the variables that
   ! have to be in place for SurfaceAlbedo and biogeophysics
   ! also set pcf%psnsun and pcf%psnsha to 0 (not included in CNSetPcf())

!dir$ concurrent
!cdir nodep
   do fp = 1,num_specialp
      p = specialp(fp)
      clm3%g%l%c%p%pps%tlai(p) = 0._r8
      clm3%g%l%c%p%pps%tsai(p) = 0._r8
      clm3%g%l%c%p%pps%elai(p) = 0._r8
      clm3%g%l%c%p%pps%esai(p) = 0._r8
      clm3%g%l%c%p%pps%htop(p) = 0._r8
      clm3%g%l%c%p%pps%hbot(p) = 0._r8
      clm3%g%l%c%p%pps%fwet(p) = 0._r8
      clm3%g%l%c%p%pps%fdry(p) = 0._r8
      clm3%g%l%c%p%pps%frac_veg_nosno_alb(p) = 0._r8
      clm3%g%l%c%p%pps%frac_veg_nosno(p) = 0._r8
      clm3%g%l%c%p%pcf%psnsun(p) = 0._r8
      clm3%g%l%c%p%pcf%psnsha(p) = 0._r8
      ! 4/14/05: PET
      ! Adding isotope code
      clm3%g%l%c%p%pc13f%psnsun(p) = 0._r8
      clm3%g%l%c%p%pc13f%psnsha(p) = 0._r8
      
   end do

!dir$ concurrent
!cdir nodep
   do fc = 1,num_specialc
      c = specialc(fc)
      clm3%g%l%c%ccf%pcf_a%psnsun(c) = 0._r8
      clm3%g%l%c%ccf%pcf_a%psnsha(c) = 0._r8
      ! 8/17/05: PET
      ! Adding isotope code
      clm3%g%l%c%cc13f%pcf_a%psnsun(c) = 0._r8
      clm3%g%l%c%cc13f%pcf_a%psnsha(c) = 0._r8
      
   end do

   ! deallocate special landunit filters
   deallocate(specialc)
   deallocate(specialp)

end subroutine CNiniSpecial
