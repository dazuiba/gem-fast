require 'fileutils'
module GemFast
  class Patcher 
     APPEND = "require 'gem-fast'\n"
     include GemFast::UI
    
   
     def patch
       if patched?
         error "already patched!"
       else
         bak
         writelines(readlines.insert(patch_index, APPEND))
         puts "patche succuess!"
       end
     end
   
     def revert
       begin
         FileUtils.cp(gem_bin_file+".bak", gem_bin_file)
         puts "revert succuess!"
       rescue Errno::ENOENT => e
        error "You never patched!"
       end
     
     end
   
     private
   
     def bak
       begin
         FileUtils.cp(gem_bin_file, gem_bin_file+".bak")
       rescue Errno::EACCES => e
         error "Permission denied. Please use sudo, cause I need write your gem file"
       end
     end
   
     def gem_bin_file
       @gem_bin_file||= begin
         if bindir = Gem::ConfigMap[:bindir]
           if File.exist?(gem_bin = File.join(bindir, "gem"))
             return gem_bin
           end
         end
         error "cannot find gem file"
       end
     end
    
   
     def patched?
       readlines[patch_index].strip == APPEND.strip
     end
   
     def patch_index
       gem_index = readlines.index{|line|line =~/^(\s*)require(\s*)[\'|\"]rubygems[\'|"\s]*$/}
       raise "cannot find require 'rubygems'" if gem_index.nil?
       gem_index+1
     end
   
     def readlines
       File.readlines(gem_bin_file)
     end
   
     def writelines(lines)
       begin
        File.open(gem_bin_file, "w") do |file|
          lines.each{|l|file<<l}
        end
       rescue Errno::EACCES => e
        error "Permission denied. Please use sudo, cause I need write your gem file"
       end
     end
   
   end
 end