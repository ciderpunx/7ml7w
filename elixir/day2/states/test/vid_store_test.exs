defmodule VidStoreTest do
  import Should
  use ExUnit.Case

  should "update count" do
    rv = VidStore.renting(video)
    assert rv.times_rented == 1
  end

  should "rent video" do
    rv = VidStore.rent video
    assert :rented == rv.state
    assert 1 == Enum.count(rv.log)
  end

  should "handle multiple transitions" do
    import VidStore
    vid = video |> rent |> return |> rent |> return |> rent
    assert 5 == Enum.count(vid.log)
    assert 3 == vid.times_rented
  end

  def video, do: %Video{title: "XMen"}
end
