CLASS lsc_zi_ad_travel_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_ad_travel_m IMPLEMENTATION.

  METHOD save_modified.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_ad_travel_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ad_travel_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_ad_travel_m RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_ad_travel_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_ad_travel_m~copytravel.

    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_ad_travel_m~recalctotalprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_ad_travel_m~rejecttravel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_ad_travel_m RESULT result.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ad_travel_m~validatecustomer.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ad_travel_m~calculatetotalprice.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_ad_travel_m\_booking.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_ad_travel_m.


ENDCLASS.

CLASS lhc_zi_ad_travel_m IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities[].
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
          IMPORTING
            number            = DATA(lv_latest_num)
            returncode        = DATA(lv_ret)
            returned_quantity = DATA(lv_ret_quan)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.

    ASSERT lv_ret_quan = lines( lt_entities ).

    DATA(lv_curr_num) = lv_latest_num - lines( lt_entities ).

    LOOP AT lt_entities INTO DATA(ls_entities).
      lv_curr_num = lv_curr_num + 1.

      APPEND VALUE #(  %cid = ls_entities-%cid
                       TravelId = lv_curr_num ) TO mapped-zi_ad_travel_m.

    ENDLOOP.



  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA(lv_max_booking) = VALUE /dmo/booking_id( ).

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY  zi_ad_travel_m BY \_Booking
    FROM CORRESPONDING #(  entities )
    LINK DATA(lt_link_booking_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_group_entity>) GROUP BY <lfs_group_entity>-TravelId.

      lv_max_booking = REDUCE #(  INIT lv_max = CONV /dmo/booking_id(  '0' )
                                  FOR ls_link IN lt_link_booking_data USING KEY entity WHERE ( source-TravelId = <lfs_group_entity>-TravelId )
                                  NEXT lv_max = COND #( WHEN lv_max < ls_link-target-BookingId THEN ls_link-target-BookingId
                                                        ELSE lv_max )
                                  ).


      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity WHERE ( TravelId = <lfs_group_entity>-TravelId )
                                 FOR ls_booking IN ls_entity-%target
                                 NEXT lv_max = COND #( WHEN lv_max < ls_booking-BookingId THEN ls_booking-BookingId
                                                       ELSE lv_max )

        ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>) USING KEY entity
      WHERE TravelId = <lfs_group_entity>-TravelId.

        LOOP AT <lfs_entities>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking>).

          APPEND CORRESPONDING #( <lfs_booking> ) TO mapped-zi_ad_booking_m ASSIGNING FIELD-SYMBOL(<lfs_booking_NEW>).

          IF <lfs_booking>-BookingId IS INITIAL.
            lv_max_booking = lv_max_booking + 10.
            <lfs_booking_NEW>-BookingId = lv_max_booking.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky OverallStatus = 'A' )  ).

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_result).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky %param = ls_result  ) ).


  ENDMETHOD.

  METHOD copyTravel.

    DATA: it_travel            TYPE TABLE FOR CREATE zi_ad_travel_m,
          it_booking_cba       TYPE TABLE FOR CREATE zi_ad_travel_m\_Booking,
          it_booking_suppl_cba TYPE TABLE FOR CREATE zi_ad_booking_m\_BookingSuppl.

    READ TABLE keys INTO DATA(ls_keys_wo_cid) WITH KEY %cid = space.
    ASSERT ls_keys_wo_cid IS INITIAL.

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_travel_f).

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r)
    FAILED DATA(lt_booking_f).

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_booking_m BY \_BookingSuppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booking_suppl_r)
    FAILED DATA(lt_booking_suppl_f).

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<lfs_travel_r>).

      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <lfs_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <lfs_travel_r> EXCEPT TravelId ) )
                      TO it_travel ASSIGNING FIELD-SYMBOL(<lfs_travel_n>).

      <lfs_travel_n>-BeginDate      = cl_abap_context_info=>get_system_date(  ).
      <lfs_travel_n>-EndDate        = cl_abap_context_info=>get_system_date(  ) + 30.
      <lfs_travel_n>-OverallStatus  = 'O'.

      APPEND VALUE #( %cid_ref = <lfs_travel_n>-%cid ) TO it_booking_cba ASSIGNING FIELD-SYMBOL(<lfs_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<lfs_booking_r>) USING KEY entity
                                                                   WHERE TravelId = <lfs_travel_r>-TravelId.


        APPEND VALUE #( %cid = <lfs_travel_n>-%cid && <lfs_booking_r>-BookingId
                       %data = CORRESPONDING #( <lfs_booking_r> EXCEPT TravelId ) )
        TO <lfs_booking>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking_n>).

        <lfs_booking_n>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <lfs_booking_n>-%cid ) TO it_booking_suppl_cba ASSIGNING FIELD-SYMBOL(<lfs_book_suppl>).

        LOOP AT lt_booking_suppl_r ASSIGNING FIELD-SYMBOL(<lfs_booking_suppl_r>)
        USING KEY entity
        WHERE TravelId = <lfs_travel_r>-TravelId AND BookingId = <lfs_booking_r>-BookingId.

          APPEND VALUE #( %cid = <lfs_travel_n>-%cid && <lfs_booking_r>-BookingId && <lfs_booking_suppl_r>-BookingSupplementId
                          %data = CORRESPONDING #( <lfs_booking_suppl_r> EXCEPT TravelId BookingId ) )
          TO <lfs_book_suppl>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking_suppl_n>).

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description  )
    WITH it_travel
    ENTITY zi_ad_travel_m
    CREATE BY \_Booking
    FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    WITH it_booking_cba
    ENTITY zi_ad_booking_m
    CREATE BY \_BookingSuppl
    FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
    WITH it_booking_suppl_cba
    MAPPED DATA(it_mapped).

    mapped-zi_ad_travel_m = it_mapped-zi_ad_travel_m.




  ENDMETHOD.

  METHOD recalcTotalPrice.

    TYPES: BEGIN OF ty_price,
             price TYPE /dmo/supplement_price,
             curr  TYPE /dmo/currency_code,
           END OF ty_price.

    DATA: lt_price TYPE TABLE OF ty_price.

    READ ENTITIES OF zi_Ad_travel_m IN LOCAL MODE
    ENTITY zi_Ad_travel_m
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    READ ENTITIES OF zi_Ad_travel_m IN LOCAL MODE
    ENTITY zi_Ad_travel_m BY \_Booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF zi_Ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_booking_m BY \_BookingSuppl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booking_suppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).
      lt_price = VALUE #( ( price = <lfs_travel>-BookingFee curr = <lfs_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<lfs_ba_booking>) USING KEY entity WHERE TravelId = <lfs_travel>-TravelId.

        APPEND VALUE #( price = <lfs_ba_booking>-FlightPrice curr = <lfs_travel>-CurrencyCode ) TO lt_price.

        LOOP AT lt_ba_booking_suppl ASSIGNING FIELD-SYMBOL(<lfs_ba_booking_suppl>) USING KEY entity WHERE TravelId  = <lfs_ba_booking>-TravelId AND
                                                                                                          BookingId = <lfs_ba_booking>-BookingId.
          APPEND VALUE #( price = <lfs_ba_booking_suppl>-Price curr = <lfs_travel>-CurrencyCode ) TO lt_price.

        ENDLOOP.

      ENDLOOP.

      DATA(lv_total) = REDUCE /dmo/supplement_price( INIT sum = 0 FOR ls_price in lt_price NEXT sum = sum + ls_price-price ).
      <lfs_travel>-totalprice = lv_total.

      CLEAr: lv_total, lt_price.

    ENDLOOP.



    MODIFY ENTITIES OF zi_Ad_travel_m IN LOCAL MODE
    ENTITY zi_Ad_travel_m
    UPDATE FIELDS ( TotalPrice )
    with CORRESPONDING #( lt_travel ).

  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF zi_ad_travel_m IN LOCAL MODE
      ENTITY zi_ad_travel_m
      UPDATE FIELDS ( OverallStatus )
      WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky OverallStatus = 'X' )  ).

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_result).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky %param = ls_result  ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m FIELDS ( TravelId OverallStatus  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel ( %tky = ls_travel-%tky
                                                    %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                                            ELSE if_abap_behv=>fc-o-enabled )
                                                    %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                                            ELSE if_abap_behv=>fc-o-enabled )
                                                    %features-%assoc-_Booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                                            ELSE if_abap_behv=>fc-o-enabled )
                                                                                            ) ).

  ENDMETHOD.

  METHOD validateCustomer.

    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m FIELDS ( CustomerId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).

    DELETE lt_cust WHERE customer_id IS INITIAL.
    CHECK lt_cust IS NOT INITIAL.


    SELECT customer_id
           FROM /dmo/customer
           FOR ALL ENTRIES IN @lt_cust
           WHERE customer_id = @lt_cust-customer_id
           INTO TABLE @DATA(lt_cust_db).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).
      IF <lfs_travel>-CustomerId IS INITIAL OR NOT line_exists( lt_cust_db[ customer_id = <lfs_travel>-customerId ] ).

        APPEND VALUE #( %tky = <lfs_travel>-%tky ) TO failed-zi_ad_travel_m.
        APPEND VALUE #( %tky = <lfs_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
          textid                = /dmo/cm_flight_messages=>customer_unkown
          severity              = if_abap_behv_message=>severity-error

        )
        %element-CustomerId = if_abap_behv=>mk-on ) TO reported-zi_ad_travel_m.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD calculateTotalPrice.

    MODIFY ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m
    EXECUTE recalcTotalPrice
    FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.
