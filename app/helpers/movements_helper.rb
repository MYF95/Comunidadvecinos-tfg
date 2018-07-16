module MovementsHelper

  def check_paid_pending_payments(apartment)
    while apartment.balance - @movement.amount < 0
      newest_pending_payment = apartment.pending_payments.where(paid: true).order('date desc').first
      break if newest_pending_payment.nil?
      newest_pending_payment.update_attributes(paid: false, paid_by: nil)
      flash[:info] = "La desasociación de movimiento ha cancelado el pago(s) más reciente(s) de la vivienda. Se han generado pagos pendientes."
    end
  end
end
