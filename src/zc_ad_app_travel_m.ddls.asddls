@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Approver Projection'
@Metadata.ignorePropagatedAnnotations: false
@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
        type: #STANDARD,
        label: 'Travel',
        value: 'TravelId'
    }
}

define root view entity zc_ad_app_travel_m
  provider contract transactional_query
  as projection on zi_ad_travel_m
{
      @UI.facet: [{
           id: 'travel',
           purpose: #STANDARD,
           position: 10,
           label: 'Travel',
           type: #IDENTIFICATION_REFERENCE
       },
       {
           id: 'booking',
           purpose: #STANDARD,
           position: 20,
           label: 'Booking',
           type: #LINEITEM_REFERENCE,
           targetElement: '_Booking'
       }]
      @UI.lineItem: [{ position: 10, importance: #HIGH } ]
      @UI.identification: [{ position: 10  }]
      @Search.defaultSearchElement: true
  key TravelId,
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.selectionField: [{ position: 10 }]
      @UI.identification: [{ position: 20  }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
         name: '/DMO/I_Agency',
         element: 'AgencyID'
      } }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.Name       as AgencyName,
      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      @UI.selectionField: [{ position: 20 }]
      @UI.identification: [{ position: 30  }]
      @Consumption.valueHelpDefinition: [{ entity: {
          name: '/DMO/I_Customer',
          element: 'CustomerID'
      } }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      @UI.identification: [{ position: 40  }]
      BeginDate,
      @UI.identification: [{ position: 50  }]
      EndDate,
      @UI.identification: [{ position: 60  }]
      @UI.lineItem: [{ position: 41 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @UI.identification: [{ position: 61  }]
      @UI.lineItem: [{ position: 42 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: {
      name: 'I_Currency',
      element: 'Currency'
      } }]
      CurrencyCode,
      @UI.identification: [{ position: 80  }]
      @UI.lineItem: [{ position: 43 }]
      Description,
      @UI.lineItem: [{ position: 70 },
      { type: #FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel'},
      { type: #FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel'} ]
      @UI.selectionField: [{ position: 30 }]
      @UI.textArrangement: #TEXT_ONLY
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
          name: '/DMO/I_Overall_Status_VH',
          element: 'OverallStatus'
      } }]
      @UI.identification: [{ position: 90 },
      { type: #FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel'},
      { type: #FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel'} ]
      @ObjectModel.text.element: [ 'OverallStatusText' ]
      OverallStatus,
      @UI.hidden: true
      _Status._Text.Text as OverallStatusText : localized,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child zc_ad_app_booking_m,
      _Currency,
      _Customer,
      _Status
}
