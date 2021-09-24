defmodule Flightex.Bookings.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking

  describe "save/1" do
    setup do
      BookingsAgent.start_link(%{})

      :ok
    end

    test "when the param are valid, return a booking uuid" do
      response =
        :booking
        |> build()
        |> BookingsAgent.save()

      {:ok, uuid} = response

      assert response == {:ok, uuid}
    end
  end

  describe "get/1" do
    setup do
      BookingsAgent.start_link(%{})

      {:ok, id: UUID.uuid4()}
    end

    test "when the user is found, return a booking", %{id: id} do
      booking = build(:booking, id: id)
      {:ok, uuid} = BookingsAgent.save(booking)

      response = BookingsAgent.get(uuid)

      expected_response =
        {:ok,
         %Flightex.Bookings.Booking{
           complete_date: ~N[2001-05-07 03:05:00],
           id: id,
           local_destination: "Bananeiras",
           local_origin: "Brasilia",
           user_id: "12345678900"
         }}

      assert response == expected_response
    end

    test "when the user wasn't found, returns an error", %{id: id} do
      booking = build(:booking, id: id)
      {:ok, _uuid} = BookingsAgent.save(booking)

      response = BookingsAgent.get("banana")

      expected_response = {:error, "Booking not found"}

      assert response == expected_response
    end
  end

  describe "list_all/0" do
    setup do
      BookingsAgent.start_link(%{})

      {:ok, id: UUID.uuid4(), another_id: UUID.uuid4()}
    end

    test "list all bookings", %{id: id, another_id: another_id} do
      :booking
      |> build(id: id, local_destination: "Salvador", local_origin: "Cuiabá")
      |> BookingsAgent.save()

      :booking
      |> build(id: another_id, local_destination: "Rio de Janeiro", local_origin: "São Paulo")
      |> BookingsAgent.save()

      expected_response = [
        %Booking{
          complete_date: ~N[2001-05-07 03:05:00],
          id: id,
          local_destination: "Salvador",
          local_origin: "Cuiabá",
          user_id: "12345678900"
        },
        %Booking{
          complete_date: ~N[2001-05-07 03:05:00],
          id: another_id,
          local_destination: "Rio de Janeiro",
          local_origin: "São Paulo",
          user_id: "12345678900"
        }
      ]

      response =
        BookingsAgent.list_all()
        |> Map.values()
        |> Enum.sort_by(&Map.fetch(&1, :local_origin))

      assert response == expected_response
    end
  end
end
