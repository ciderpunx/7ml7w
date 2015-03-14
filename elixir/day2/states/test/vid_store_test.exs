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

  should "renting, losing, finding and returning same as renting and returning" do
    import VidStore
    vid1 = video |> rent |> lose |> find |> return
    vid2 = video |> rent |> return
    # renting a video, then losing it and finding it then returning it
    # gives the same state as just rent and returning it
    assert vid1.state == vid2.state
    # admin checks
    assert 6 == Enum.count(vid1.log)
    assert 4 == Enum.count(vid2.log)
    assert 1 == vid1.times_rented
    assert 1 == vid2.times_rented
  end

  should "have record of hook activity after returning" do
    import VidStore
    vid = video |> rent |> return
    assert vid.log == ["After returning XMen\n", "Returning XMen\n",
                       "Before returning XMen\n", "Renting XMen\n"]
  end

  should "handle multiple transitions" do
    import VidStore
    vid = video |> rent |> return |> rent |> return |> rent
    assert 9 == Enum.count(vid.log)
    assert 3 == vid.times_rented
  end

  should "choke on bad video (no state field)" do
    import VidStore
    assert_raise(KeyError, fn -> badvideo |> rent end)
  end

  def video, do: %Video{title: "XMen"}

  def badvideo, do: %BadVideo{title: "XMen"}

end
