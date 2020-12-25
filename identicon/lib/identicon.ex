defmodule Identicon do
  def main(string) do
    string
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_only_even()
    |> build_pixel_map()
    |> create_image()
    |> save_image(string)
  end

  def filter_only_even(image) do
    %Identicon.Image{grid: grid,} = image
    even_grid = grid |> Enum.filter(fn {value,_index} -> rem(value, 2) == 0 end)
    Map.put(image, :grid, even_grid)
  end

  def save_image(final_image, input_string) do
    File.write("#{input_string}.png",final_image)
  end

  def create_image(image) do
    %Identicon.Image{pixel_map: pixel_map, color: color} = image
    final_image = :egd.create(250,250)
    fill = :egd.color(color)
    Enum.each(pixel_map, fn {start,stop} ->
      :egd.filledRectangle(final_image, start, stop, fill)
    end)
    :egd.render(final_image)
  end

  def build_pixel_map(image) do
    %Identicon.Image{grid: grid,} = image
    pixel_map = Enum.map(grid,fn {_v,index} ->
      horizontal = rem(index,5)*50
      vertical = div(index,5)*50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end)
    Map.put(image, :pixel_map, pixel_map)
  end

  def build_grid(image) do
    %Identicon.Image{hex: hex_list, } = image
    grid = hex_list
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&Identicon.mirror_row/1)
    |> List.flatten()
    |> Enum.with_index()
    Map.put(image, :grid, grid) #..> another way of updating the Map
  end

  def mirror_row(row) do
    [r,g | _tail ] = row
    row ++ [g,r]
  end

  def pick_color(image) do
    %Identicon.Image{hex: hex_list } = image
    [r,g,b | _tail ] = hex_list
    %Identicon.Image{image | color: {r,g,b}}
  end

  def hash_input(string) do
    hex = :crypto.hash(:md5,string)
    |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end
end
