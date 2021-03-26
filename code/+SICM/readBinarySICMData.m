function o = readBinarySICMData(fname)
   % Generate temporary dircetory and unpack the data.
    % A sicm-file is a gzipped tar archive. It will be unpacked into a
    % temporary directory.
    [ ~, purefilename, ext ] = fileparts(fname);
    tempdirname = tempname;
    gunzip(fname, tempdirname);
    untar([tempdirname filesep purefilename], tempdirname);
    
    % information about the size etc. are stored in json format in a file
    % called settings.json
    fid = fopen([tempdirname filesep 'settings.json']);
    cjson = textscan(fid,'%s');
    fclose(fid);
    sjson = cjson{1}{1};
    info = jsondecode(sjson);
    xsize = str2double(info.x_px);
    ysize = str2double(info.y_px);
    
    filelist = dir(tempdirname);
    
    for i=1:size(filelist,1)
        [ ~, purefilename2, ext ] = fileparts(filelist(i).name);
        if isempty(ext) && ~strcmp(purefilename2, purefilename)
            datafile = purefilename2;
        end
    end
    fid = fopen([tempdirname filesep datafile]);
    img = fread(fid,[ysize,xsize],'uint16');
    fclose(fid);
    % Read additional info, if available
    fid = fopen([tempdirname filesep datafile '.info']);
    cinfo2 = textscan(fid, '%s');
    fclose(fid);
    sinfo2 = [cinfo2{1}{:}];
    rmdir(tempdirname, 's');
    
    o = SICM.SICMScan.FromZDataGrid(img);
    o.setXSize(str2double(info.x_Size));
    o.setYSize(str2double(info.y_Size));
    try
        info2 = parse_json(sinfo2);
        o.duration = info2.client_scan_duration;  
    catch
        
    end
    

    

    