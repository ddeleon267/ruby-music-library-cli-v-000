class Song
  extend Concerns::Findable
  attr_accessor :name, :artist, :genre

  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = (artist) if artist != nil
    #better to say 'if artist'
    self.genre=(genre) if genre != nil
      #better to say 'if genre'
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def self.create(song)
    song = Song.new(song)
    song.save
    song
    #new(name, artist, genre).tap{|s| s.save}
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end

  def self.find_by_name(name)
    self.all.detect { |song| song.name == name }
  end

  def self.find_or_create_by_name(name)
    if self.find_by_name(name) == nil
      self.create(name)
    else
      self.find_by_name(name)
    end

    #self.find_by_name(name) || self.create(name)
  end

  def self.new_from_filename(filename)
    mp3_removed = filename.gsub('.mp3', '')
    artist = mp3_removed.split(" - ")[0]
    song = mp3_removed.split(" - ")[1]
    genre = mp3_removed.split(" - ")[1]
    
    new_song = Song.new
    new_song.artist = Artist.new
    binding.pry
    new_song.genre = genre
    new_song.save
  end

  def self.create_from_filename(filename)
    new_song = self.new_from_filename(filename)
    new_song.save
  end

end
