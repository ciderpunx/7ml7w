defmodule ConncreteTest do
  use ExUnit.Case
  import Should

  should "update count" do
    rented_video = VideoStore.renting(video)
    assert rented_video.times_rented == 1
  end

  should "rent video" do
    rv = VideoStore.Concrete.rent video
    assert :rented == rv.state
    assert 1 == Enum.count(rv.log)
  end

  should "handle multiple transitions" do
    import VideoStore.Concrete
    vid = video |> rent |> return |> rent |> return |> rent
    assert 5 == Enum.count(vid.log)
    assert 3 == vid.times_rented
  end

  def video, do: %Video{title: "Test"}
end
