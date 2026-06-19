@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppliment Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_ad_booksupl_m
  as select from ztbl_bksupl_m
  association        to parent zi_ad_booking_m as _Booking        on  $projection.TravelId  = _Booking.TravelId
                                                                  and $projection.BookingId = _Booking.BookingId
  association [1..1] to zi_ad_travel_m as _Travel on $projection.TravelId =  _Travel.TravelId                                                      
  association [1..1] to /DMO/I_Supplement      as _Suppliment     on  $projection.SupplementId = _Suppliment.SupplementID
  association [1..*] to /DMO/I_SupplementText  as _SupplimentText on  $projection.SupplementId = _SupplimentText.SupplementID
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,

      //Associations
      _Suppliment,
      _SupplimentText,
      _Travel,

      //Compositions
      _Booking
}
