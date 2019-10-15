require 'vstool'
require 'image_info'
require 'yaml'
#$LOAD_PATH.unshift File.expand_path('../../lib/opencvtool/lib', __FILE__)
#require 'opencvtool'

#Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }
def deleteall(delthem)
	if FileTest.directory?(delthem) then
		Dir.foreach( delthem ) do |file|
			next if /^\.+$/ =~ file
			deleteall(delthem.sub(/\/+$/,"") + "/" + file)
		end
		p "#{delthem} deleting..."
		begin		
			Dir.rmdir(delthem)
		rescue
			p $!
		end
	else
		p "#{delthem} deleting..."
		begin
		  File.delete(delthem)
		rescue
		  p $!
		end
	end
end

def setup_file(destfile)
	src_dir = File.expand_path('../fixtures/data',__FILE__)
	filename = File.basename(destfile)
	dest_dir = File.dirname(destfile)
	dest = File.join(dest_dir, filename)
	src = File.join(src_dir, filename)
	FileUtils.mkdir_p(dest_dir) unless File.directory?(dest_dir)
	FileUtils.copy(src, dest)
end


def setup_data(destdir)
	src_dir = File.expand_path('../fixtures/VS2007data',__FILE__)
	basename = File.basename(destdir)
	dest_dir = File.dirname(destdir)
	src = File.join(src_dir, basename)
	FileUtils.mkdir_p(dest_dir) unless File.directory?(dest_dir)
	FileUtils.cp_r(src, dest_dir)
end

def filename_for(path, opts = {})
	extname = File.extname(path).sub(/\./,'')
	if opts[:ext]
		extname = opts[:ext].to_s
	end
	dirname = File.dirname(path)
	dirname = File.join(dirname,opts[:insert_path]) if opts[:insert_path]
	File.join(dirname, File.basename(path, ".*") + ".#{extname}")
end
