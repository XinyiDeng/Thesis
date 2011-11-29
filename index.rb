require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'models'
require "base64"
require 'RMagick'

set :views, File.dirname(__FILE__) + '/views'

get '/' do

"
<title>memento</title>
<style>
body {
background-color:333333;
background-position:center; 
background-image:url('http://memento.heroku.com/images/letter.png');
background-repeat:
no-repeat;
background-attachment:
fixed
}
</style>
<body>

</body>"
end

get "/capsules/new" do
erb :new_capsule
end

get "/capsules/:id" do
# show the image plus some info about it
@capsule = Capsule.get params[:id]
erb :capsule
end

post '/capsules' do
  
  #def iphone_upload
  # @data = request.POST[:imageData].unpack("m")[0]
  # fileout = "/var/www/test.jpg"
  # File.open(fileout, 'w') {|f| f.write(@data) }
  # end
  
  puts "************FILE UPLOAD*********************"
  
  #puts params[:file].unpack("m")[0].class #params.inspect
   
  #puts Base64.decode64(params[:file]).class
    
    puts "cats are monkeys"
    
  puts "************/FILE UPLOAD*********************"

#params[:file] = params[:file].unpack("m")[0]

puts "Params:"
puts params

puts "File:"
puts params[:file]
puts "Email:"
puts params[:email]

   begin
   image = Magick::Image.read(params[:file][:tempfile].path)[0]

	#if image.size > 500000
	#	return 400, "photo too big"
	#end	

   ##image = Magick::Image.from_blob(params[:file][:tempfile].read).first
   image.auto_orient!
# generate a random time
t = Time.now
currentyear = t.year
year = currentyear + rand(6)
month = rand(11)
day = rand(28)


#e = params[:date]
#dueDate = e.string_to_date

dueDate = params[:date]

puts "Formatted Date:"
puts dueDate

#DateTime.new(year, month, day, 12),

c = Capsule.create(:created_at => t, :dueDate => dueDate,  :email => params[:email])
   c.path = c.path_string
   c.save
  
  # puts "http://memento.heroku.com/capusles/#{c.id}"
  
  
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, image.to_blob, "hindsight-itp", :access => :public_read)


  rescue Exception => e
  	puts e
  	500
  end
  
end