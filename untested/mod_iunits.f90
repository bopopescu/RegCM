      module mod_iunits
      implicit none
!
! COMMON /FILES/
!
      character(17) :: oldsav
!
! COMMON /IUNITS/
!
      integer :: iutbat , iutbc , iutchem , iutchsrc , iutdat , iutin , &
               & iutin1 , iutlak , iutopt , iutrad , iutrs , iutsav ,   &
               & iutsub , mindisp
!
! COMMON /LDATA/
!
      integer :: iin , iout , lcount , numpts
!
! COMMON /GENREC/

      integer :: nrcout
      integer :: nrcbat
      integer :: nrcsub
      integer :: nrcchem
      integer :: nrcrad

      end module mod_iunits
