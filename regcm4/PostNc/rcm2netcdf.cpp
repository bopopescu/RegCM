/***************************************************************************
 *   Copyright (C) 2008-2009 by Graziano Giuliani                          *
 *   graziano.giuliani at aquila.infn.it                                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details. (see COPYING)            *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 *                                                                         *
 *   LIC: GPL                                                              *
 *                                                                         *
 ***************************************************************************/

#include <netcdf.hh>
#include <cstring>
#include <iostream>
#include <cstdio>
#include <ctime>
#include <libgen.h>
#include <rcmio.h>
#include <rcminp.h>
#include <rcmNc.h>
#include <calc.h>

using namespace rcm;

int main(int argc, char *argv[])
{
  if (argc != 3)
  {
    std::cerr << std::endl
        << "Howdy there, wrong number of arguments." << std::endl
        << std::endl << "I need two arguments:" << std::endl << std::endl
        << "    regcm.in  - path to regcm.in of RegCM model v4" << std::endl
        << "    expname   - a (meaningful) name for this expertiment"
        << std::endl
        << std::endl << "Example:" << std::endl
        << std::endl << "     " << argv[0]
        << " /home/regcm/Run/regcm.in ACWA_reference" << std::endl << std::endl
        << "I will assume in this case that:" << std::endl << std::endl
        << "   -) The output directory of the model is '/home/regcm/Run/output'"
        << std::endl
        << "   -) All output files You want to process are inside this dir"
        << std::endl
        << "   -) The regcm.in file is relative to those files"
        << std::endl
        << "   -) In case of subgridding, the fort.11 link is present "
        << "in '/home/regcm/Run'" << std::endl << std::endl;
   return -1;
  }

  try
  {
    char *regcmin = strdup(argv[1]);
    rcminp inpf(regcmin);

    char *rundir = dirname(regcmin);
    char outdir[PATH_MAX];
    snprintf(outdir, 256, "%s%s%s", rundir, separator, "output");

    rcmio rcmout(outdir, true, true);
    header_data outhead(inpf);
    rcmout.read_header(outhead);

    char fname[PATH_MAX];

    if (rcmout.has_atm)
    {
      std::cout << "Found Atmospheric data ATM and processing";
      atmodata a(outhead);
      sprintf(fname, "ATM_%s_%d.nc", argv[2], outhead.idate1);
      rcmNcAtmo atmnc(fname, argv[2], outhead);
      atmcalc c(outhead);
      t_atm_deriv d;
      // Add Atmospheric variables
      while ((rcmout.atmo_read_tstep(a)) == 0)
      {
        std::cout << ".";
        c.do_calc(a, d);
        atmnc.put_rec(a, d);
      }
      std::cout << "Done." << std::endl;
    }

    if (rcmout.has_srf)
    {
      std::cout << "Found Surface data SRF and processing";
      srfdata s(outhead);
      sprintf(fname, "SRF_%s_%d.nc", argv[2], outhead.idate1);
      rcmNcSrf srfnc(fname, argv[2], outhead);
      // Add Surface variables
      srfcalc c(outhead);
      t_srf_deriv d;
      while ((rcmout.srf_read_tstep(s)) == 0)
      {
        std::cout << ".";
        c.do_calc(s, d);
        srfnc.put_rec(s, d);
      }
      std::cout << "Done." << std::endl;
    }

    if (rcmout.has_rad)
    {
      std::cout << "Found Radiation data RAD and processing";
      raddata r(outhead);
      sprintf(fname, "RAD_%s_%d.nc", argv[2], outhead.idate1);
      rcmNcRad radnc(fname, argv[2], outhead);
      // Add Radiation variables
      while ((rcmout.rad_read_tstep(r)) == 0)
      {
        std::cout << ".";
        radnc.put_rec(r);
      }
      std::cout << "Done." << std::endl;
    }

    if (rcmout.has_che)
    {
      std::cout << "Found Chemical data CHE and processing";
      chedata c(outhead);
      sprintf(fname, "CHE_%s_%d.nc", argv[2], outhead.idate1);
      rcmNcChe chenc(fname, argv[2], outhead);
      // Add Chemical tracers variables
      while ((rcmout.che_read_tstep(c)) == 0)
      {
        std::cout << ".";
        chenc.put_rec(c);
      }
      std::cout << "Done." << std::endl;
    }

    if (rcmout.has_sub)
    {
      std::cout << "Found Surface Subgrid data SUB and processing";
      subdom_data subdom;
      rcmout.read_subdom(outhead, subdom);
      subdata s(outhead, subdom);
      sprintf(fname, "SUB_%s_%d.nc", argv[2], outhead.idate1);
      rcmNcSub subnc(fname, argv[2], outhead, subdom);
      // Add Subgrid variables
      while ((rcmout.sub_read_tstep(s)) == 0)
      {
        std::cout << ".";
        subnc.put_rec(s);
      }
      std::cout << "Done." << std::endl;
    }

    outhead.free_space( );
  }
  catch (const char *e)
  {
    std::cerr << "Error : " << e << std::endl;
    return -1;
  }
  catch (...)
  {
    return -1;
  }

  std::cout << "Successfully completed processing." << std::endl;
  return 0;
}
