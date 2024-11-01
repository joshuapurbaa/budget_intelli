enum StatusSchedulePayment {
  active,
  paid,
  overdue,
}

String getStatusSchedulePayment(StatusSchedulePayment status) {
  switch (status) {
    case StatusSchedulePayment.paid:
      return 'Paid';
    case StatusSchedulePayment.active:
      return 'Active';
    case StatusSchedulePayment.overdue:
      return 'Overdue';
  }
}

StatusSchedulePayment getStatusSchedulePaymentEnum(String status) {
  switch (status) {
    case 'Paid':
      return StatusSchedulePayment.paid;
    case 'Active':
      return StatusSchedulePayment.active;
    case 'Overdue':
      return StatusSchedulePayment.overdue;
    default:
      return StatusSchedulePayment.active;
  }
}
