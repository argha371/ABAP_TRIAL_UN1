CLASS zcl_ajd_eml_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AJD_EML_PRACTICE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    READ ENTITY zi_ad_travel_m
*    FROM VALUE #( ( %key-TravelId = '00004145'
*                    %control   = VALUE #(   AgencyId    = if_abap_behv=>mk-on
*                                            CustomerId  = if_abap_behv=>mk-on
*                                            BeginDate   = if_abap_behv=>mk-on
*                     ) ) )
*    RESULT DATA(lt_res_short)
*    FAILED DATA(lt_fail_short).
*
*    IF lt_fail_short IS NOT INITIAL.
*      out->write( lt_fail_short  ).
*    ELSE.
*      out->write( lt_res_short  ).
*    ENDIF.

*    READ ENTITY zi_ad_travel_m
*    FIELDS ( AgencyId CustomerId EndDate )
*    WITH VALUE #( ( %key-TravelId = '00004145' ) )
*    RESULT DATA(lt_res_short)
*    FAILED DATA(lt_fail_short).
*
*    IF lt_fail_short IS NOT INITIAL.
*      out->write( lt_fail_short  ).
*    ELSE.
*      out->write( lt_res_short  ).
*    ENDIF.

    READ ENTITY zi_ad_travel_m
   ALL FIELDS
   WITH VALUE #( ( %key-TravelId = '00004145' ) )
   RESULT DATA(lt_res_short)
   FAILED DATA(lt_fail_short).

    IF lt_fail_short IS NOT INITIAL.
      out->write( lt_fail_short  ).
    ELSE.
      out->write( lt_res_short  ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
