@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Approver Projection View'
@Metadata.ignorePropagatedAnnotations: false
@UI.headerInfo: {
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title: {
        type: #STANDARD,
        label: 'Booking',
        criticalityRepresentation: #WITHOUT_ICON,
        value: 'BookingId'
    }
}
define view entity zc_ad_app_booking_m
  as projection on zi_ad_booking_m
{
      @UI.facet: [{

           id: 'Booking',
           purpose: #STANDARD,
           position: 10,
           label: 'Booking',
           type: #IDENTIFICATION_REFERENCE
       } ]
      @Search.defaultSearchElement: true
  key TravelId,

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key BookingId,

      @UI.identification: [{ position: 20, importance: #HIGH }]
      @UI.lineItem: [{ position: 20 }]
      BookingDate,

      @UI.identification: [{ position: 30 }]
      @UI.lineItem: [{ position: 30 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
         name: '/DMO/I_Customer',
         element: 'CustomerID'
      } }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,

      @UI.identification: [{ position: 40 }]
      @UI.lineItem: [{ position: 40 }]
      @Consumption.valueHelpDefinition: [{ entity: {
         name: '/DMO/I_Carrier',
         element: 'AirlineID'
      } }]
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name      as CarrierName,

      @UI.identification: [{ position: 50 }]
      @UI.lineItem: [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: {
         name: '/DMO/I_Flight',
         element: 'ConnectionID'
      },
      additionalBinding: [{ element: 'ConnectionID' , localElement: 'ConnectionId' },
      { element: 'AirlineID' , localElement: 'CarrierId' },
      { element: 'CurrencyCode' , localElement: 'CurrencyCode' },
      { element: 'Price' , localElement: 'FlightPrice' }] }]
      ConnectionId,

      @UI.identification: [{ position: 60 }]
      @UI.lineItem: [{ position: 60 }]
      @Consumption.valueHelpDefinition: [{ entity: {
        name: '/DMO/I_Flight',
        element: 'FlightDate'
      },
      additionalBinding: [{ element: 'FlightDate' , localElement: 'FlightDate' },
      { element: 'AirlineID' , localElement: 'CarrierId' },
      { element: 'CurrencyCode' , localElement: 'CurrencyCode' },
      { element: 'Price' , localElement: 'FlightPrice' }] }]
      FlightDate,

      @UI.identification: [{ position: 70 }]
      @UI.lineItem: [{ position: 70 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,

      @Consumption.valueHelpDefinition: [{ entity: {
      name: 'I_Currency',
      element: 'Currency'
      } }]
      CurrencyCode,

      @UI.lineItem: [{ position: 80 }]
      @UI.identification: [{ position: 80 }]
      @UI.textArrangement: #TEXT_ONLY
      @Consumption.valueHelpDefinition: [{ entity: {
         name: '/DMO/I_Booking_Status_VH',
         element: 'BookingStatus'
      } }]
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      
      @UI.hidden: true
      _Booking_Status._Text.Text as BookingStatusText : localized,
      
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _BookingSuppl,
      _Booking_Status,
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent zc_ad_app_travel_m
}
