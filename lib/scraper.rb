require 'nokogiri'
require 'open-uri'

require_relative './course.rb'

class Scraper

  def get_page
    @doc ||= Nokogiri::HTML(open("http://learn-co-curriculum.github.io/site-for-scraping/courses"))
  end

  def get_courses
    get_page.css('.post')
  end

  def make_courses
    get_courses
    .map { |course_el| [[:title, course_el.css('h2').text], [:schedule, course_el.css('.date').text], [:description, course_el.css('p').text]].to_h }
    .map { |course_info| Course.new(course_info) }
  end

  def print_courses
    self.make_courses
    Course.all.each do |course|
      if course.title
        puts "Title: #{course.title}"
        puts "  Schedule: #{course.schedule}"
        puts "  Description: #{course.description}"
      end
    end
  end
end
