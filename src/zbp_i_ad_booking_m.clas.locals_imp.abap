CLASS lhc_zi_ad_booking_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_ad_booking_m\_Bookingsuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_ad_booking_m RESULT result.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ad_booking_m~calculatetotalprice.

ENDCLASS.

CLASS lhc_zi_ad_booking_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA: lv_max_book_suppl_id TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_booking_m BY \_BookingSuppl
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_book_suppls).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_book_suppl>) GROUP BY <lfs_book_suppl>-%tky.

      lv_max_book_suppl_id = REDUCE #(  INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                      FOR ls_link IN lt_book_suppls USING KEY entity WHERE (  source-TravelId = <lfs_book_suppl>-TravelId
                                                                                          AND source-BookingId = <lfs_book_suppl>-BookingId )
                                      NEXT lv_max = COND #( WHEN lv_max < ls_link-target-BookingSupplementId THEN ls_link-target-BookingSupplementId
                                                            ELSE lv_max )
                                      ).

      lv_max_book_suppl_id = REDUCE #( INIT lv_max = lv_max_book_suppl_id
                                FOR ls_entity IN entities USING KEY entity WHERE (   TravelId  = <lfs_book_suppl>-TravelId
                                                                                 AND BookingId = <lfs_book_suppl>-BookingId )
                                FOR ls_booking_SUPPL IN ls_entity-%target
                                NEXT lv_max = COND #( WHEN lv_max < ls_booking_SUPPL-BookingSupplementId THEN ls_booking_SUPPL-BookingSupplementId
                                                      ELSE lv_max )

       ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>) USING KEY entity
              WHERE TravelId = <lfs_book_suppl>-TravelId AND
                    BookingId = <lfs_book_suppl>-BookingId.

        LOOP AT <lfs_entities>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking_SUPPL>).

          APPEND CORRESPONDING #( <lfs_booking_SUPPL> ) TO mapped-zi_ad_booksupl_m ASSIGNING FIELD-SYMBOL(<lfs_booking_suppl_NEW>).
          IF <lfs_booking_SUPPL>-BookingSupplementId IS INITIAL.
            lv_max_book_suppl_id = lv_max_book_suppl_id + 1.


            <lfs_booking_suppl_NEW>-BookingSupplementId = lv_max_book_suppl_id.
          ENDIF.
        ENDLOOP.
      ENDLOOP.


    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_ad_travel_m IN LOCAL MODE
    ENTITY zi_ad_travel_m BY \_Booking
    FIELDS ( TravelId BookingStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_booking).

    result = VALUE #( FOR ls_booking IN lt_booking ( %tky = ls_booking-%tky
                                                     %features-%assoc-_BookingSuppl = COND #( WHEN ls_booking-%data-BookingStatus = 'A'
                                                                                              THEN if_abap_behv=>fc-o-enabled ELSE
                                                                                                   if_abap_behv=>fc-o-disabled ) ) ).



  ENDMETHOD.

  METHOD calculateTotalPrice.

    DATA: lt_travel_keys TYPE STANDARD TABLE OF zi_ad_travel_m WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    lt_travel_keys = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).

    MODIFY ENTITIES OF zi_ad_travel_m IN LOCAL MODE
      ENTITY zi_ad_travel_m
      EXECUTE recalcTotalPrice
      FROM CORRESPONDING #( keys ).


  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
