defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Bookings.Report, as: BookingReport
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser

  def start_agents do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})
  end

  defdelegate create_user(parans), to: CreateOrUpdateUser, as: :call
  defdelegate create_booking(params), to: CreateOrUpdateBooking, as: :call
  defdelegate get_booking(booking_id), to: BookingAgent, as: :get
  defdelegate generate_report(from_date, to_date), to: BookingReport, as: :generate
end
