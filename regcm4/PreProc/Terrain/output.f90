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

      subroutine output(nunitc,iunc,iy,jx,dsinm,clat,clon,plat,plon,    &
                      & iproj,htgrid,htsdgrid,lndout,xlat,xlon,dlat,    &
                      & dlon,xmap,dattyp,dmap,coriol,snowam,igrads,     &
                      & ibigend,kz,sigma,mask,ptop,nsg,truelatl,        &
                      & truelath,grdfac,filout,lsmtyp,sanda,sandb,claya,&
                      & clayb,frac_lnd,nveg,aertyp,texout,frac_tex,ntex,&
                      & lcoarse)

      use mod_interfaces

      implicit none
!
! Dummy arguments
!
      character(7) :: aertyp
      real(4) :: clat , clon , dsinm , grdfac , plat , plon , ptop ,    &
               & truelath , truelatl
      character(5) :: dattyp
      character(*) :: filout
      integer :: ibigend , igrads , iy , jx , kz , nsg , ntex ,         &
               & nunitc , nveg , iunc
      character(6) :: iproj
      character(4) :: lsmtyp
      real(4) , dimension(iy,jx) :: claya , clayb , coriol , dlat ,     &
                                  & dlon , dmap , htgrid , htsdgrid ,   &
                                  & lndout , mask , sanda , sandb ,     &
                                  & snowam , texout , xlat , xlon , xmap
      real(4) , dimension(iy,jx,nveg) :: frac_lnd
      real(4) , dimension(iy,jx,ntex) :: frac_tex
      real(4) , dimension(kz+1) :: sigma
      logical :: lcoarse
      intent (in) aertyp , clat , claya , clayb , clon , coriol ,       &
                & dattyp , dlat , dlon , dmap , dsinm , filout ,        &
                & frac_lnd , frac_tex , grdfac , htgrid , htsdgrid ,    &
                & ibigend , igrads , iproj , iy , jx , kz ,             &
                & lndout , lsmtyp , nsg , ntex , nunitc , nveg ,        &
                & plat , plon , ptop , sanda , sandb , snowam , texout ,&
                & truelath , truelatl , xlat , xlon , xmap , lcoarse ,  &
                & sigma , iunc
      intent (inout) mask
!
! Local variables
!
      real(4) :: alatmax , alatmin , alonmax , alonmin , centeri ,      &
               & centerj , lat0 , lat1 , lon0 , lon1 , rlatinc , rloninc
      integer :: i , j , k , nx , ny
!
      alatmin = 999999.
      alatmax = -999999.
      alonmin = 999999.
      alonmax = -999999.
      nx = 0
      ny = 0

      do i = 1 , iy
        do j = 1 , jx
          if ( (lsmtyp=='BATS' .and.                                    &
             &  (lndout(i,j)>20. .or. lndout(i,j)<0.)) .or.             &
             & (lsmtyp=='USGS' .and.                                    &
             &  (lndout(i,j)>25. .or. lndout(i,j)<0.)) ) then
            print * , i , j , lndout(i,j)
            stop 999
          end if
        end do
      end do

      if ( .not. lcoarse .or.                                           &
         & ( dattyp/='FVGCM' .and. dattyp/='NRP2W' .and.  &
         &   dattyp/='GFS11' .and. dattyp/='EH5OM') ) then
        write (nunitc,rec=1) iy , jx , kz , dsinm , clat , clon , plat ,&
                           & plon , grdfac , iproj , (sigma(k),k=1,kz+1)&
                           & , ptop , igrads , ibigend , truelatl ,     &
                           & truelath
      else
        write (*,*) 'please input lon0,lon1,lat0,lat1'
        write (*,*) 'Note: lon0 < lon1, and lat0 < lat1'
        read (*,*) lon0 , lon1 , lat0 , lat1
        write (nunitc,rec=1) iy , jx , kz , dsinm , clat , clon , plat ,&
                           & plon , grdfac , iproj , (sigma(k),k=1,kz+1)&
                           & , ptop , igrads , ibigend , truelatl ,     &
                           & truelath , lon0 , lon1 , lat0 , lat1
      end if

      write (nunitc,rec=2) ((htgrid(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=3) ((htsdgrid(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=4) ((lndout(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=5) ((xlat(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=6) ((xlon(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=7) ((dlat(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=8) ((dlon(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=9) ((xmap(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=10) ((dmap(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=11) ((coriol(i,j),j=1,jx),i=1,iy)
      write (nunitc,rec=12) ((snowam(i,j),j=1,jx),i=1,iy)
      do i = 1 , iy
        do j = 1 , jx
          if ( lsmtyp=='BATS' ) then
            if ( lndout(i,j)>13.5 .and. lndout(i,j)<15.5 ) then
              mask(i,j) = 0.0
            else
              mask(i,j) = 2.0
            end if
          else if ( lsmtyp=='USGS' ) then
            if ( lndout(i,j)>24.5 ) then
              mask(i,j) = 0.0
            else
              mask(i,j) = 2.0
            end if
          else
          end if
        end do
      end do
      write (nunitc,rec=13) ((mask(i,j),j=1,jx),i=1,iy)
      if ( lsmtyp=='USGS' ) then
        write (nunitc,rec=14) ((sanda(i,j),j=1,jx),i=1,iy)
        write (nunitc,rec=15) ((sandb(i,j),j=1,jx),i=1,iy)
        write (nunitc,rec=16) ((claya(i,j),j=1,jx),i=1,iy)
        write (nunitc,rec=17) ((clayb(i,j),j=1,jx),i=1,iy)
        do k = 1 , nveg
          write (nunitc,rec=17+k) ((frac_lnd(i,j,k),j=1,jx),i=1,iy)
        end do
      end if
      if ( aertyp(7:7)=='1' ) then
        if ( lsmtyp=='BATS' ) then
          write (nunitc,rec=14) ((texout(i,j),j=1,jx),i=1,iy)
          do k = 1 , ntex
            write (nunitc,rec=14+k) ((frac_tex(i,j,k),j=1,jx),i=1,iy)
          end do
        else if ( lsmtyp=='USGS' ) then
          write (nunitc,rec=18+nveg) ((texout(i,j),j=1,jx),i=1,iy)
          do k = 1 , ntex
            write (nunitc,rec=18+nveg+k)                                &
                 & ((frac_tex(i,j,k),j=1,jx),i=1,iy)
          end do
        else
        end if
      end if
      close (nunitc)
 
      if ( igrads==1 ) then
        if ( lcoarse ) then
          write (iunc,99004) trim(filout), '.INFO'
        else if ( nsg>1 ) then
          write (iunc,99005) trim(filout), nsg , '.INFO'
        end if
        write (iunc,99007)
        if ( ibigend==1 ) then
          write (iunc,99008)
        else
          write (iunc,99009)
        end if
        write (iunc,99010)
        if ( iproj=='LAMCON' .or. iproj=='ROTMER' ) then
          do j = 1 , jx
            if ( xlat(1,j)<alatmin ) alatmin = xlat(1,j)
            if ( xlat(iy,j)>alatmax ) alatmax = xlat(iy,j)
          end do
          do i = 1 , iy
            do j = 1 , jx
              if ( clon>=0.0 ) then
                if ( xlon(i,j)>=0.0 ) then
                  alonmin = amin1(alonmin,xlon(i,j))
                  alonmax = amax1(alonmax,xlon(i,j))
                else if ( abs(clon-xlon(i,j))<abs(clon-(xlon(i,j)+360.))&
                        & ) then
                  alonmin = amin1(alonmin,xlon(i,j))
                  alonmax = amax1(alonmax,xlon(i,j))
                else
                  alonmin = amin1(alonmin,xlon(i,j)+360.)
                  alonmax = amax1(alonmax,xlon(i,j)+360.)
                end if
              else if ( xlon(i,j)<0.0 ) then
                alonmin = amin1(alonmin,xlon(i,j))
                alonmax = amax1(alonmax,xlon(i,j))
              else if ( abs(clon-xlon(i,j))<abs(clon-(xlon(i,j)-360.)) )&
                      & then
                alonmin = amin1(alonmin,xlon(i,j))
                alonmax = amax1(alonmax,xlon(i,j))
              else
                alonmin = amin1(alonmin,xlon(i,j)-360.)
                alonmax = amax1(alonmax,xlon(i,j)-360.)
              end if
            end do
          end do
          rlatinc = dsinm*0.001/111./2.
          rloninc = dsinm*0.001/111./2.
          ny = 2 + nint(abs(alatmax-alatmin)/rlatinc)
          nx = 1 + nint(abs((alonmax-alonmin)/rloninc))
 
          centerj = jx/2.
          centeri = iy/2.
        end if
        if ( iproj=='LAMCON' ) then        ! Lambert projection
          write (iunc,99011) jx , iy , clat , clon , centerj , centeri ,&
                         & truelatl , truelath , clon , dsinm , dsinm
          write (iunc,99012) nx + 2 , alonmin - rloninc , rloninc
          write (iunc,99013) ny + 2 , alatmin - rlatinc , rlatinc
        else if ( iproj=='POLSTR' ) then   !
        else if ( iproj=='NORMER' ) then
          write (iunc,99014) jx , xlon(1,1) , xlon(1,2) - xlon(1,1)
          write (iunc,99015) iy
          write (iunc,99016) (xlat(i,1),i=1,iy)
        else if ( iproj=='ROTMER' ) then
          write (*,*) 'Note that rotated Mercartor (ROTMER)' ,          &
                     &' projections are not supported by GrADS.'
          write (*,*) '  Although not exact, the eta.u projection' ,    &
                     &' in GrADS is somewhat similar.'
          write (*,*) ' FERRET, however, does support this projection.'
          write (iunc,99017) jx , iy , plon , plat , dsinm/111000. ,    &
                         & dsinm/111000.*.95238
          write (iunc,99012) nx + 2 , alonmin - rloninc , rloninc
          write (iunc,99013) ny + 2 , alatmin - rlatinc , rlatinc
        else
          write (*,*) 'Are you sure your map projection is right ?'
          stop
        end if
        write (iunc,99018) 1 , 1000.
        write (iunc,99019) 1
        if ( lsmtyp=='BATS' ) then
          if ( aertyp(7:7)=='1' ) then
            write (iunc,99020) 13 + ntex + 1
          else
            write (iunc,99020) 13
          end if
        else if ( lsmtyp=='USGS' ) then
          if ( aertyp(7:7)=='1' ) then
            write (iunc,99020) 42 + ntex + 1
          else
            write (iunc,99020) 42
          end if
        else
        end if
        write (iunc,99021) 'head    ' , 'header information         '
        write (iunc,99021) 'ht      ' , 'surface elevation          '
        write (iunc,99021) 'htsd    ' , 'surface elevation std. dev.'
        write (iunc,99021) 'landuse ' , 'surface landuse type       '
        write (iunc,99021) 'xlat    ' , 'latitude  of cross points  '
        write (iunc,99021) 'xlon    ' , 'longitude of cross points  '
        write (iunc,99021) 'dlat    ' , 'latitude  of dot points    '
        write (iunc,99021) 'dlon    ' , 'longitude of dot points    '
        write (iunc,99021) 'xmap    ' , 'map factors of cross points'
        write (iunc,99021) 'dmap    ' , 'map factors of dot points  '
        write (iunc,99021) 'coriol  ' , 'coriol force               '
        write (iunc,99021) 'snowam  ' , 'initial snow amount        '
        write (iunc,99021) 'mask    ' , 'land/sea mask              '
        if ( lsmtyp=='USGS' ) then
          write (iunc,99021) 'sanda   ' , 'sand percentage (0-30cm)   '
          write (iunc,99021) 'sandb   ' , 'sand percentage (30-100cm) '
          write (iunc,99021) 'claya   ' , 'clay percentage (0-30cm)   '
          write (iunc,99021) 'clayb   ' , 'clay percentage (30-100cm) '
          write (iunc,99021) 'per1    ' , 'percentage landuse type 1  '
          write (iunc,99021) 'per2    ' , 'percentage landuse type 2  '
          write (iunc,99021) 'per3    ' , 'percentage landuse type 3  '
          write (iunc,99021) 'per4    ' , 'percentage landuse type 4  '
          write (iunc,99021) 'per5    ' , 'percentage landuse type 5  '
          write (iunc,99021) 'per6    ' , 'percentage landuse type 6  '
          write (iunc,99021) 'per7    ' , 'percentage landuse type 7  '
          write (iunc,99021) 'per8    ' , 'percentage landuse type 8  '
          write (iunc,99021) 'per9    ' , 'percentage landuse type 9  '
          write (iunc,99021) 'per10   ' , 'percentage landuse type 10 '
          write (iunc,99021) 'per11   ' , 'percentage landuse type 11 '
          write (iunc,99021) 'per12   ' , 'percentage landuse type 12 '
          write (iunc,99021) 'per13   ' , 'percentage landuse type 13 '
          write (iunc,99021) 'per14   ' , 'percentage landuse type 14 '
          write (iunc,99021) 'per15   ' , 'percentage landuse type 15 '
          write (iunc,99021) 'per16   ' , 'percentage landuse type 16 '
          write (iunc,99021) 'per17   ' , 'percentage landuse type 17 '
          write (iunc,99021) 'per18   ' , 'percentage landuse type 18 '
          write (iunc,99021) 'per19   ' , 'percentage landuse type 19 '
          write (iunc,99021) 'per20   ' , 'percentage landuse type 20 '
          write (iunc,99021) 'per21   ' , 'percentage landuse type 21 '
          write (iunc,99021) 'per22   ' , 'percentage landuse type 22 '
          write (iunc,99021) 'per23   ' , 'percentage landuse type 23 '
          write (iunc,99021) 'per24   ' , 'percentage landuse type 24 '
          write (iunc,99021) 'per25   ' , 'percentage landuse type 24 '
        end if
        if ( aertyp(7:7)=='1' ) then
          write (iunc,99021) 'texture ' , 'soil texture               '
          write (iunc,99021) 'text01  ' , 'Sand              frac.    '
          write (iunc,99021) 'text02  ' , 'Loamy Sand        frac.    '
          write (iunc,99021) 'text03  ' , 'Sandy Loam        frac.    '
          write (iunc,99021) 'text04  ' , 'Silt Loam         frac.    '
          write (iunc,99021) 'text05  ' , 'Silt              frac.    '
          write (iunc,99021) 'text06  ' , 'Loam              frac.    '
          write (iunc,99021) 'text07  ' , 'Sandy Clay Loam   frac.    '
          write (iunc,99021) 'text08  ' , 'Silty Clay Loam   frac.    '
          write (iunc,99021) 'text09  ' , 'Clay Loam         frac.    '
          write (iunc,99021) 'text10  ' , 'Sandy Clay        frac.    '
          write (iunc,99021) 'text11  ' , 'Silty Clay        frac.    '
          write (iunc,99021) 'text12  ' , 'Clay              frac.    '
          write (iunc,99021) 'text13  ' , 'OM                frac.    '
          write (iunc,99021) 'text14  ' , 'Water             frac.    '
          write (iunc,99021) 'text15  ' , 'Bedrock           frac.    '
          write (iunc,99021) 'text16  ' , 'Other             frac.    '
          write (iunc,99021) 'text17  ' , 'No data           frac.    '
        end if
        write (iunc,99022)
        close (iunc)
      end if
99004 format ('dset ^',a,a)
99005 format ('dset ^',a,i0.3,a)
99007 format ('title RegCM domain information')
99008 format ('options big_endian')
99009 format ('options little_endian')
99010 format ('undef -9999.')
99011 format ('pdef ',i4,1x,i4,1x,'lcc',7(1x,f7.2),1x,2(f7.0,1x))
99012 format ('xdef ',i4,' linear ',f7.2,1x,f7.4)
99013 format ('ydef ',i4,' linear ',f7.2,1x,f7.4)
99014 format ('xdef ',i3,' linear ',f9.4,' ',f9.4)
99015 format ('ydef ',i3,' levels')
99016 format (10F7.2)
99017 format ('pdef ',i4,1x,i4,1x,'eta.u',2(1x,f7.3),2(1x,f9.5))
99018 format ('zdef ',i1,' levels ',f7.2)
99019 format ('tdef ',i1,' linear 00z01Jan2001 1mo')
99020 format ('vars ',i2)
99021 format (a8,'0 99 ',a26)
99022 format ('endvars')
!
      end subroutine output
