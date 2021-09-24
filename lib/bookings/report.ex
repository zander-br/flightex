defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_bookings()

    File.write(filename, booking_list)
  end

  def generate(from_date, to_date) do
    booking_list = build_bookings(from_date, to_date)

    File.write("report.csv", booking_list)
  end

  defp build_bookings() do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(&booking_string/1)
  end

  defp build_bookings(from_date, to_date) do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.filter(&do_dates_are_in_the_range?(&1, from_date, to_date))
    |> Enum.map(&booking_string/1)
  end

  defp do_dates_are_in_the_range?(%Booking{complete_date: complete_date}, from_date, to_date) do
    NaiveDateTime.compare(complete_date, from_date) != :lt and
      NaiveDateTime.compare(complete_date, to_date) != :gt
  end

  defp booking_string(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
