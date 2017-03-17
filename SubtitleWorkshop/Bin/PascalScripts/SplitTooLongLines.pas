{
Splits all lines at [.!?\n]. Useful when some retard has joined too
many lines and you don't want to keep splitting them while working.
Durations are split equally to each part, not based on part length.
}

program SplitLines;

// -----------------------------------------------------------------------------

type
  subparts = array [0..100] of string;

var
  i: Integer;
  j: Integer;
  si: Integer;
  prev_pos: Integer;
  ci: Integer;
  
  parts: subparts;

  txt: String;
  subtxt: String;
  
  abs_start: Integer;
  abs_end: Integer;
  time_index: Integer;
  interval: Integer;
  
  len: Integer;

begin
  i := 0;
  
  while GetSubtitleCount > i do
  begin
     if IsSubtitleSelected(i) = true then
     begin
		si := 0;
		txt := GetSubtitleText(i);
		prev_pos := 0;
		
		for ci := 0 to len do
			parts[ci] := '';
			
		len := 1;
			
		for j := 1 to Length(GetSubtitleText(i)) - 1 do
		begin
			if (txt[j] = '.') or (txt[j] = '!') or (txt[j] = '?') or (txt[j] = #13) then
			begin
				if txt[j] <> txt[j + 1] then
				begin
					parts[si] := copy(GetSubtitleText(i), prev_pos, j - prev_pos + 1);
					len := len + 1;
					prev_pos := j + 1;
					si := si + 1;
				end;
			end;
		end;
		
		parts[si] := copy(GetSubtitleText(i), prev_pos, Length(GetSubtitleText(i)));
		
		abs_start := GetSubtitleInitialTime(i);
		abs_end := GetSubtitleFinalTime(i);
		time_index := abs_start;
		
		interval := round((abs_end - abs_start) / len);
		
		for j := 0 to len - 1 do
		begin
			if j = 0 then
			begin
				SetSubtitleText(i + j, parts[j]);   
				SetSubtitleFinalTime(i + j, abs_start + interval * (j + 1) - 1);
			end else
				InsertSubtitle(i + j, abs_start + interval * j, abs_start + interval * (j + 1) - 1, parts[j], parts[j]);
		end;
     end;
	 i := i + 1;
  end;
end.
