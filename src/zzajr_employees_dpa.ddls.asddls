@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.deliveryClass: #APPLICATION_DATA
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Draft Table Entity for'
define table entity ZZAJR_EMPLOYEES_DPA
{
  key UUID : SYSUUID_X16;
  EmpID : abap.char( 50 );
  Name : abap.char( 50 );
  Age : abap.int8;
  DateOfJoining : abap.datn;
  SalaryCurr : abap.cuky;
  @Semantics.amount.currencyCode: 'SalaryCurr'
  Salary : abap.curr( 17, 2 );
  Active : ABAP_BOOLEAN;
  CreatedBy : abap.char( 50 );
  CreatedAt : abap.utclong;
  ChangedBy : abap.char( 50 );
  ChangedAt : abap.utclong;
  LocalCreatedBy : ABP_CREATION_USER;
  LocalCreatedAt : ABP_CREATION_TSTMPL;
  LocalLastChangedBy : ABP_LOCINST_LASTCHANGE_USER;
  LocalLastChangedAt : ABP_LOCINST_LASTCHANGE_TSTMPL;
  LastChangedAt : ABP_LASTCHANGE_TSTMPL;
  include SYCH_BDL_DRAFT_ADMIN_INC.* signature only;
}
