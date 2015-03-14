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

  should "renting losing finding and returning same as renting and returning" do
    import VideoStore.Concrete
    vid1 = video |> rent |> lose |> find |> return
    vid2 = video |> rent |> return
    # renting a video, then losing it and finding it then returning it
    # gives the same state as just rent and returning it
    assert vid1.state == vid2.state
    # admin checks
    assert 4 == Enum.count(vid1.log)
    assert 2 == Enum.count(vid2.log)
    assert 1 == vid1.times_rented
    assert 1 == vid2.times_rented
  end

  should "handle multiple transitions" do
    import VideoStore.Concrete
    vid = video |> rent |> return |> rent |> return |> rent
    assert 5 == Enum.count(vid.log)
    assert 3 == vid.times_rented
  end

  def video, do: %Video{title: "Test"}
end
