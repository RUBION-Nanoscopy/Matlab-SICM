function info = getInterfaceInformation(self)
% reads the available additional information in the GUI-metadata at the end
% of the *.m-files and returns them as a structure
    [p, ~, ~] = fileparts(which(class(self)));

    dirinfo = dir([p filesep '*.m']);
    info = {};
    for finfo = dirinfo'
        if finfo.isdir
            continue
        end
        gmd = lcl_read_gmd([p filesep finfo.name]);
        if ~isempty(gmd) && isfield(gmd, 'Type')
            type = gmd.Type;
            if strcmp(type(1), '''')
                type = type(2:end);
            end
            if strcmp(type(end), '''')
                type = type(1:end-1);
            end
            
            gmd = rmfield(gmd, 'Type');
            [~,gmd.file,gmd.fileext] = fileparts(finfo.name);
            if ~isfield(info, type)
                info.(type) = {};
            end
            info.(type)(end+1) = {gmd};
            
        end
    
    end

end

function gmd = lcl_read_gmd(fn)
    gmd = {};
    fid = fopen(fn, "r");
    inGMD = false;
    while ~feof(fid)
        tline = fgetl(fid);     
        if ~inGMD
            matches = strfind(tline, '%+BEGIN GUIMETADATA: Do not delete');
            if ~isempty(matches)
                inGMD = true;
            end
        else
            [tok,~] = regexp(tline, '%\+GMD\s(?<field>\w*):\s(?<value>.*)', 'names');
            
            if numel(tok) > 0
                fchar = lcl_unquote(tok.field);
                gmd.(fchar) = eval(tok.value);
            end
        end   
    end
    fclose(fid);
end

function str = lcl_unquote(str)
    wasstring = false;
    if isstring(str)
        wasstring = true;
        str = char(str);
    end
    if strcmp(str(1), '''')
        str = str(2:end);
    end
	if strcmp(str(end), '''')
        str = str(1:end-1);
    end
    if wasstring
        str = string(str);
    end
end