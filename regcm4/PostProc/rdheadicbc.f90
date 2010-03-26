      subroutine rdheadicbc(ix,jx,nx,ny,kx,clat,clon,ds,pt,sigf,sigh, &
                          & sighrev,xplat,xplon,f,xmap,dmap,xlat,xlon,  &
                          & zs,zssd,ls,iin,inhead,ibyte)
 
      implicit none
!
! Dummy arguments
!
      real(4) :: clat , clon , ds , pt , xplat , xplon
      integer :: ibyte , iin , nx , ix , ny , jx , kx
      character(70) :: inhead
      real(4) , dimension(nx,ny) :: dmap , f , ls , xlat , xlon , xmap ,&
                              &  zs , zssd
      real(4) , dimension(kx+1) :: sigf
      real(4) , dimension(kx) :: sigh , sighrev
      intent (in) ibyte , iin , inhead , nx , ix , ny , jx , kx
      intent (out) dmap , f , ls , sighrev , xlat , xlon , xmap , zs ,  &
                 & zssd
      intent (inout) clat , clon , ds , pt , sigf , sigh , xplat , xplon
!
! Local variables
!
      real(4) :: grdfac
      integer :: i , ibigend , ierr , igrads , j , k , kk , ni , nj , nk
      character(6) :: proj
      real(4) , dimension(ix,jx) :: tmp2d
!
      open (iin,file=inhead,status='old',form='unformatted',            &
          & recl=ix*jx*ibyte,access='direct')
      read (iin,rec=1,iostat=ierr) ni , nj , nk , ds , clat , clon ,    &
                                 & xplat , xplon , grdfac , proj ,      &
                                 & sigf , pt , igrads , ibigend
      print * , 'ni,nj,nk,ds='
      print * , ni , nj , nk , ds
      print * , 'sigf='
      print * , sigf
      print * , 'pt,clat,clon,xplat,xplon,proj='
      print * , pt , clat , clon , xplat , xplon , proj
      if ( ni/=jx .or. nj/=ix .or. kx/=nk ) then
        print * , 'Grid Dimensions DO NOT MATCH'
        print * , '  jx=' , jx , 'ix=' , ix , 'kx=' , kx
        print * , '  ni=' , ni , 'nj=' , nj , 'nk=' , nk
        print * , '  Also check ibyte in icbc.param: ibyte= ' , ibyte
        stop 'BAD DIMENSIONS (SUBROUTINE RDHEADICBC)'
      end if
!     print*,'ZS'
      read (iin,rec=2,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          zs(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'ZSSD'
      read (iin,rec=3,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          zssd(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'LU'
      read (iin,rec=4,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          ls(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'XLAT'
      read (iin,rec=5,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          xlat(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'XLON'
      read (iin,rec=6,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          xlon(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'XMAP'
      read (iin,rec=9,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          xmap(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'DMAP'
      read (iin,rec=10,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          dmap(i,j) = tmp2d(i+1,j+1)
        end do
      end do
!     print*,'F'
      read (iin,rec=11,iostat=ierr) tmp2d
      do j = 1 , ny
        do i = 1 , nx
          f(i,j) = tmp2d(i+1,j+1)
        end do
      end do
 
      if ( ierr/=0 ) then
        print * , 'END OF FILE REACHED'
        print * , '  Check ibyte in postproc.param: ibyte= ' , ibyte
        stop 'EOF (SUBROUTINE RDHEADICBC)'
      end if
 
      do k = 1 , kx
        kk = kx - k + 1
        sigh(k) = (sigf(k)+sigf(k+1))/2.
        sighrev(kk) = sigh(k)
      end do
 
      end subroutine rdheadicbc
