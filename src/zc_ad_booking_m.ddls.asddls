@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection View'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity zc_ad_booking_m
  as projection on zi_ad_booking_m
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name      as CarrierName,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _Booking_Status._Text.Text as BookingStatusText : localized, 
      LastChangedAt,
      /* Associations */
      _BookingSuppl : redirected to composition child ZC_AD_BOOKSUPL_M,
      _Booking_Status,
      _Carrier,
      _Connection,
      _Customer,
      _Travel       : redirected to parent zc_ad_travel_m
}
