classdef (ConstructOnLoad) SICMScanChangedData < event.EventData
   properties
      Field
      NeedsRedraw

   end
   
   methods
      function data = SICMScanChangedData(field, needsRedraw)
         data.Field = field;
         data.NeedsRedraw = needsRedraw;

      end
   end
end