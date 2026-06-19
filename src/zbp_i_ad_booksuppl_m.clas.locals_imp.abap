CLASS lhc_zi_ad_booksupl_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ad_booksupl_m~calculateTotalPrice.

ENDCLASS.

CLASS lhc_zi_ad_booksupl_m IMPLEMENTATION.

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

