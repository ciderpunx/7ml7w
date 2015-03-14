defmodule VideoStore do
  def renting(v) do
    vid = log v, "Renting #{v.title}"
    %{vid | times_rented: (v.times_rented+1)}
  end

  def returning(v) do
    log v, "Returning #{v.title}"
  end

  def losing(v) do
    log v, "Losing #{v.title}"
  end

  def finding(v) do
    log v, "Finding #{v.title}"
  end

  def log(v,msg) do
    %{v | log: [msg|v.log]}
  end
end
