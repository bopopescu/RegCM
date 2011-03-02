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

      module mod_humid

      use mod_constants
      use m_realkinds
!
      contains

      subroutine humid1(t,q,ps,pt,sigma,ni,nj,nk)
      implicit none
!
      integer :: ni , nj , nk
      real(sp) :: ps
      real(dp) :: pt
      real(sp) , dimension(ni,nj,nk) :: q , t
      real(sp) , dimension(nk) :: sigma
      intent (in) ni , nj , nk , ps , pt , sigma , t
      intent (inout) q
!
      real(sp) :: lh , p , qs , satvp
      integer :: i , j , k
!
!     THIS ROUTINE REPLACES SPECIFIC HUMIDITY BY RELATIVE HUMIDITY
!
      do i = 1 , ni
        do j = 1 , nj
          do k = 1 , nk
            p = (pt+sigma(k)*ps)*10.        ! PRESSURE AT LEVEL K
            lh = lh0 - lh1*(t(i,j,k)-tzero)
            satvp = lsvp1*dexp(lsvp2*lh*(1./tzero-1./t(i,j,k)))
            qs = ep2*satvp/(p-satvp)        ! SAT. MIXING RATIO
            q(i,j,k) = amax1(q(i,j,k)/qs,0.0)
          end do
        end do
      end do
      end subroutine humid1
!
!-----------------------------------------------------------------------
!
      subroutine humid1_o(t,q,ps,sigma,ptop,im,jm,km)
      implicit none
!
      integer :: im , jm , km
      real(dp) :: ptop
      real(sp) , dimension(im,jm) :: ps
      real(sp) , dimension(im,jm,km) :: q , t
      real(sp) , dimension(km) :: sigma
      intent (in) im , jm , km , ps , ptop , sigma , t
      intent (inout) q
!
      real(sp) :: lh , p , qs , satvp
      integer :: i , j , k
!
!     THIS ROUTINE REPLACES SPECIFIC HUMIDITY BY RELATIVE HUMIDITY
!     DATA ON SIGMA LEVELS
!
      do k = 1 , km
        do j = 1 , jm
          do i = 1 , im
            p = sigma(k)*(ps(i,j)-ptop) + ptop
            lh = lh0 - lh1*(t(i,j,k)-tzero)       ! LATENT HEAT OF EVAP.
            satvp = lsvp1*exp(lsvp2*lh*(rtzero-1./t(i,j,k)))
                                                      ! SATURATION VAP PRESS.
            qs = ep2*satvp/(p-satvp)                 ! SAT. MIXING RATIO
            q(i,j,k) = amax1(q(i,j,k)/qs,0.0)
          end do
        end do
      end do
      end subroutine humid1_o
!
!-----------------------------------------------------------------------
!
      subroutine humid1fv(t,q,p3d,ni,nj,nk)
      implicit none
!
      integer :: ni , nj , nk
      real(sp) , dimension(ni,nj,nk) :: p3d , q , t
      intent (in) ni , nj , nk , p3d , t
      intent (inout) q
!
      real(sp) :: lh , qs , satvp
      integer :: i , j , k
!
!     THIS ROUTINE REPLACES SPECIFIC HUMIDITY BY RELATIVE HUMIDITY
!
      do i = 1 , ni
        do j = 1 , nj
          do k = 1 , nk
            if ( p3d(i,j,k)>-9990. ) then
              lh = lh0 - lh1*(t(i,j,k)-tzero)  ! LATENT HEAT OF EVAP.
              satvp = lsvp1*exp(lsvp2*lh*(rtzero-1./t(i,j,k)))
                                                   ! SATURATION VAP PRESS.
              qs = ep2*satvp/(p3d(i,j,k)-satvp)   ! SAT. MIXING RATIO
              q(i,j,k) = amax1(q(i,j,k)/qs,0.0)    !ALREADY MIXING RATIO
            else
              q(i,j,k) = -9999.
            end if
          end do
        end do
      end do
      end subroutine humid1fv
!
!-----------------------------------------------------------------------
!
      subroutine humid2(t,q,ps,pt,sigma,ni,nj,nk)
      implicit none
!
      integer :: ni , nj , nk
      real(dp) :: pt
      real(sp) , dimension(ni,nj) :: ps
      real(sp) , dimension(ni,nj,nk) :: q , t
      real(sp) , dimension(nk) :: sigma
      intent (in) ni , nj , nk , ps , pt , sigma , t
      intent (inout) q
!
      real(sp) :: lh , p , qs , satvp
      integer :: i , j , k
!
!     THIS ROUTINE REPLACES RELATIVE HUMIDITY BY SPECIFIC HUMIDITY
!
      do i = 1 , ni
        do j = 1 , nj
          do k = 1 , nk
            p = (pt+sigma(k)*ps(i,j))*10.
            lh = lh0 - lh1*(t(i,j,k)-tzero)
            satvp = lsvp1*exp(lsvp2*lh*(rtzero-1./t(i,j,k)))
            qs = ep2*satvp/(p-satvp)
            q(i,j,k) = amax1(q(i,j,k)*qs,0.0)
          end do
        end do
      end do
!
      end subroutine humid2
!
      end module mod_humid
