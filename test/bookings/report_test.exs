defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00\n"

      Flightex.create_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content in date range" do
      params_booking = %{
        complete_date: ~N[2021-08-15 12:00:00],
        local_origin: "São Paulo",
        local_destination: "Rio de Janeiro",
        user_id: "12345678900"
      }

      params_another_booking = %{
        complete_date: ~N[2021-09-20 18:00:00],
        local_origin: "Rio de Janeiro",
        local_destination: "Cuiabá",
        user_id: "12345678900"
      }

      content = "12345678900,São Paulo,Rio de Janeiro,2021-08-15 12:00:00\n"

      Flightex.create_booking(params_booking)
      Flightex.create_booking(params_another_booking)
      Report.generate(~N[2021-08-01 00:00:01], ~N[2021-08-31 23:59:59])
      {:ok, file} = File.read("report.csv")

      assert file =~ content
    end
  end
end
