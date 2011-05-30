module GemFast
  class RemoteFetcher < Gem::RemoteFetcher 
    
    def download(spec, source_uri, install_dir = Gem.dir)
      return super unless scheme_supported?(source_uri)
      source_uri = source_uri.to_s
      #Fix issue #1
      if source_uri =~/gems\.github\.com/ 
        source_uri = "http://gems.rubyforge.org/" 
      end 

      if source_uri =~/\/$/ 
      else
        source_uri << "/"
      end 
      CurlUnsafeDownloadStrategy.new(source_uri + "gems/#{spec.file_name}", spec.file_name).fetch
    end
    
    def fetch_path(uri, mtime = nil, head = false)
      return super unless scheme_supported?(uri)
      
      path = CurlUnsafeDownloadStrategy.new(uri,nil).fetch
      data = nil
      File.open(path, "rb"){|f|data = f.read}
      data = Gem.gunzip data if data and not head and uri.to_s =~ /gz$/
      data
    end
    
    def fetch_size(url)
      puts "fetch size : #{url}"
      super
    end
    
    private
    def scheme_supported?(uri)
      uri && uri.to_s.strip =~ %r[^https?://]
    end
    
    def ensure_tmp_dir(install_dir)
      gem_file_name = spec.file_name
      local_gem_path = File.join RUBYGEMPLUS_CACHE, gem_file_name
      FileUtils.mkdir_p cache_dir rescue nil unless File.exist? cache_dir
    end
  end
  
  
  class AbstractDownloadStrategy
    include Util
  
    def initialize url, name=nil
      @url=url
      @unique_token="#{name}" unless name.to_s.empty? or name == '__UNKNOWN__'
    end
    
    def expand_safe_system_args args
      args.each_with_index do |arg, ii|
        if arg.is_a? Hash
          unless ARGV.verbose?
            args[ii] = arg[:quiet_flag]
          else
            args.delete_at ii
          end
          return args
        end
      end
      # 2 as default because commands are eg. svn up, git pull
      args.insert(2, '-q') unless ARGV.verbose?
      return args
    end

    def quiet_safe_system *args
      safe_system(*expand_safe_system_args(args))
    end
  end

  class CurlDownloadStrategy <AbstractDownloadStrategy
    attr_reader :tarball_path
      
    def initialize url, name
      super
      if @unique_token
        @tarball_path=File.join(RUBYGEMPLUS_CACHE,@unique_token)
      else
        @tarball_path=File.join(RUBYGEMPLUS_CACHE,File.basename(@url.to_s))
      end
    end
  
    def cached_location
      @tarball_path
    end

    # Private method, can be overridden if needed.
    def _fetch
      curl @url, '-o', @tarball_path
    end
    
    
    def fetch
      if fetch_lastest_specs
        return @tarball_path
      end
      
      say "Downloading #{@url}"
      unless File.exist?(@tarball_path)
        begin
          _fetch
        rescue Exception
          # ignore_interrupts { @tarball_path.unlink if @tarball_path.exist? }
          raise
        end
      else
        puts "File already downloaded and cached to #{RUBYGEMPLUS_CACHE}"
      end
      return @tarball_path # thus performs checksum verification
    end
  
  private
    
    def fetch_lastest_specs
      if @url.to_s =~ /\/latest_specs\.(.+)\.gz$/ && latest_specs_too_old?
        say "lastest_specs too old, updating..."
        say "Downloading #{@url}"
        _fetch
        true
      else
        false
      end
    end
    
    def latest_specs_too_old?
      if file = Dir[File.join(RUBYGEMPLUS_CACHE,"latest_specs.*.gz")].first
        (Time.now - File.stat(file).ctime)/(3600*24) > 7
      else
        false
      end
    end
  
    def chdir
      entries=Dir['*']
      case entries.length
        when 0 then raise "Empty archive"
        when 1 then Dir.chdir entries.first rescue nil
      end
    end
  end

  # Download via an HTTP POST.
  # Query parameters on the URL are converted into POST parameters
  class CurlPostDownloadStrategy <CurlDownloadStrategy
    def _fetch
      base_url,data = @url.split('?')
      curl base_url, '-d', data, '-o', @tarball_path
    end
    
    
  end

  # Use this strategy to download but not unzip a file.
  # Useful for installing jars.
  class NoUnzipCurlDownloadStrategy <CurlDownloadStrategy
    def stage
      FileUtils.cp @tarball_path, File.basename(@url)
    end
  end

  # This Download Strategy is provided for use with sites that
  # only provide HTTPS and also have a broken cert.
  # Try not to need this, as we probably won't accept the forulae
  # into trunk.
  class CurlUnsafeDownloadStrategy <CurlDownloadStrategy
    def _fetch
      curl @url, '--insecure', '-o', @tarball_path
    end
  end
  
end