         ctl-opt main(main) dftactgrp(*no);
      //------------------------------------------------------------------//
      //                                                                  //
      // Send SMS with TWILIO                                             //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 07.2022 *                                                 //
      //------------------------------------------------------------------//
      // SQL-Options                                                      //
      //------------------------------------------------------------------//

         exec sql set option datfmt=*iso, timfmt=*iso, commit=*none,
                             decmpt=*period, closqlcsr=*endactgrp;

      //------------------------------------------------------------------//
      // Datastructure SMS                                                //
      //------------------------------------------------------------------//

         dcl-ds  DsSMS       qualified inz;
                  from       varchar(30);             // SMS-from
                  to         varchar(30);             // SMS-to
                  text       varchar(256);            // SMS-text
         end-ds;

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocUrl      varchar(90);
         dcl-s   LocHeader   varchar(128);
         dcl-s   LocData     varchar(1000);
         dcl-s   LocResponse varchar(128);

           LocUrl     = 'http://IBM i IP:8080/sendsms';

           exec sql
            set :LocHeader = JSON_OBJECT(
                'header' value 'Content-Type,application/json; charset=utf-8'
            );

           DsSMS.from = '+49678901234';
           DsSMS.to   = '+49171456789';
           DsSMS.text = 'My Message to you!';

           LocData    = crtJson(DsSMS);

           exec sql
            set :LocResponse = QSYS2.HTTP_POST(:LocUrl, :LocData, :LocHeader);

         end-proc;
      //------------------------------------------------------------------//
      // create JSON data                                                 //
      // {"from":"+123456789", "to":"+123456789" , "text":"My Message"}   //
      //------------------------------------------------------------------//
         dcl-proc crtJson;
         dcl-pi *n           like(LocData);
                 PiSMS       likeds(DsSMS) const;
         end-pi;

         dcl-s   LocData     varchar(1000);           // JSON-Data

           exec sql
            set :LocData = JSON_OBJECT(
               'from'    value trim(:PiSMS.from),
               'to'      value trim(:PiSMS.to),
               'text'    value trim(:PiSMS.text)
           );

           return LocData;

         end-proc;
      //------------------------------------------------------------------// 
