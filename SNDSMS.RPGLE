         ctl-opt main(main) dftactgrp(*no) alloc(*teraspace) bnddir('YAJL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Send JSON data to DataQueue                                      //
      // Please check the correct CCSID in Line 93                        //
      //-----------------                                                 //
      // R.Ross 10.2016 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include yajl/qrpglesrc,yajl_h

      //------------------------------------------------------------------//
      // Send Data to DTAQ                                                //
      //------------------------------------------------------------------//

         dcl-pr snddtaq      extpgm('QSNDDTAQ');
                 ##dtqname   like(d#dtqname)   const;
                 ##dtqlib    like(d#dtqlib)    const;
                 ##dtqlength like(d#dtqlength) const;
                 ##dtqdata   char(32766)       const options(*varsize);
         end-pr;

      //------------------------------------------------------------------//
      // Variables DTQ-API                                                //
      //------------------------------------------------------------------//

         dcl-s   d#dtqname   char(10)   inz('SNDSMSQ');        // DTQ-Name
         dcl-s   d#dtqlib    char(10)   inz('MYLIB');          // DTQ-Lib
         dcl-s   d#dtqlength packed(05) inz(%size(d#dtqdata)); // DTQ-Length
         dcl-s   d#dtqwait   packed(05) inz(-1);               // DTQ-Wait
         dcl-s   d#dtqdata   char(5000);                       // DTQ-Data

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   body        varchar(4000);           // SMS-Body
         dcl-s   to          varchar(30);             // SMS-To
         dcl-s   from        varchar(30);             // SMS-From

         dcl-s   jsondata    varchar(5000);           // JSON-Data

         dcl-s   index       uns(10);                 // Index

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

           for index = 1 to 5;                         // 5 SMS in a loop                       
             body = 'Hello from Node ' + %char(index); // SMS-Body
             to   = '+123456789';                      // SMS-To
             from = '+123456789';                      // SMS-From

             d#dtqdata = crtjson(body:to:from);        // create JSON data 

             snddtaq(d#dtqname:d#dtqlib:d#dtqlength:d#dtqdata); // Send to DTQ
           endfor;

           snddtaq(d#dtqname:d#dtqlib:d#dtqlength:crtjson('*end':to:from));

         end-proc;
      //------------------------------------------------------------------//
      // Procedure - create JSON data - for example                       //
      // {"body":"Hello", "to":"+123456789", "from":"+123456789"}         //
      //------------------------------------------------------------------//
         dcl-proc crtjson export;
         dcl-pi *n           like(jsondata);          // JSON-Data
                 ##body      like(body) const options(*varsize);
                 ##to        like(to)   const options(*varsize);
                 ##from      like(from) const options(*varsize);
         end-pi;

         dcl-s   p#size      int(10) inz(%size(jsondata)); // JSON-length
         dcl-s   p#len       int(10) inz;             // Data-length
         dcl-s   p#rc        int(10) inz;             // ReturnCode
         dcl-s   p#json_p    pointer;                 // JSON-Pointer
         dcl-s   p#jsondata  like(jsondata);          // JSON-Data
        
           dealloc(n) p#json_p;                       // JSON-Pointer
           p#json_p = %alloc(p#size);                 // Alloc Pointer

           yajl_genopen(*off);                        // *on = pretty Code

           yajl_beginobj();
            yajl_addchar('body':##body);
            yajl_addchar('to'  :##to);
            yajl_addchar('from':##from);
           yajl_endobj();
                                                               
           p#rc = yajl_copybuf(37:p#json_p:p#size:p#len); // CCSID 37 = USA
                                                          // CCSID 1141 = GER     
           if p#rc = *zero and p#len > *zero;
              p#jsondata = %str(p#json_p:p#len);
           endif;

           yajl_genclose();

           return p#jsondata;

         end-proc;
      //------------------------------------------------------------------// 
