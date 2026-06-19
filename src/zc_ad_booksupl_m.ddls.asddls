@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppliment Projection View'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity ZC_AD_BOOKSUPL_M
  as projection on zi_ad_booksupl_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplemenDesc' ]
      SupplementId,
      _SupplimentText.Description as SupplemenDesc : localized,
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Booking : redirected to parent zc_ad_booking_m,
      _Suppliment,
      _SupplimentText,
      _Travel  : redirected to zc_ad_travel_m
}
