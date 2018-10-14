program Adapter;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  (* Its interface *)
  TTarget = class abstract
    function Request: string; virtual; abstract;
  end;

  (* A client accessed to this. *)
  TAdaptee = class(TTarget)
    function Request: string; override;
  end;

  (* Object Adapter uses composition and can wrap classes or interfaces, or both.*)
  (* Redirect call to Adaptee. It is loose coupling of client and adapter.*)
  (*
    *It can do this since it contains, as a private, encapsulated member,
    *the class or interface object instance it wraps.
  *)
  TObjectAdapter = class
    fAdaptee: TAdaptee;
    function SpecialRequest: string;
    constructor Create(adaptee: TAdaptee);
  end;

  (* Class Adapter uses inheritance and can only wrap a class.*)
  (* This plain old inheritance. *)
  (* It cannot wrap an interface since by definition*)
  (* it must derive from some base class as Adaptee in example*)
  (*
    * Can't reuse Class Adapter without rewrite code
    * You need implements other adapter with other method in other class.
  *)
   TClassAdapter = class(TAdaptee)
   function SpecialRequest: string;
   end;

  { TObjectAdapter }

constructor TObjectAdapter.Create;
begin
  fAdaptee := TAdaptee.Create;
end;

function TObjectAdapter.SpecialRequest: string;
begin
  Result := fAdaptee.Request;
end;

{ TClassAdapter }

 function TClassAdapter.SpecialRequest: string;
 begin
//use inherited Request as SpecialRequest
 Result:= inherited Request;
 end;

{ TAdaptee }

function TAdaptee.Request: string;
begin
  Result := 'Adaptee';
end;

var
  clientObject: TObjectAdapter;
  clientClass:TClassAdapter;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    clientObject := TObjectAdapter.Create(TAdaptee.Create);
    clientClass:= TClassAdapter.Create;

    WriteLn('Call method Object Adapter: '+clientObject.SpecialRequest);
    WriteLn('Call method Class Adapter: '+clientClass.SpecialRequest);

    WriteLn(#13#10+ 'Press any key to continue...');
    ReadLn;

    clientObject.Free;
    clientClass.Free;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
