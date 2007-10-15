{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is ArrayList.pas.                                                              }
{                                                                                                  }
{ The Initial Developer of the Original Code is Jean-Philippe BEMPEL aka RDM. Portions created by  }
{ Jean-Philippe BEMPEL are Copyright (C) Jean-Philippe BEMPEL (rdm_30 att yahoo dott com)          }
{ All rights reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{   Florent Ouchet (outchy)                                                                        }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ The Delphi Container Library                                                                     }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Last modified: $Date::                                                                         $ }
{ Revision:      $Rev::                                                                          $ }
{ Author:        $Author::                                                                       $ }
{                                                                                                  }
{**************************************************************************************************}

unit JclArrayLists;

{$I jcl.inc}

interface

uses
  Classes,
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  {$IFDEF SUPPORTS_GENERICS}
  {$IFDEF CLR}
  System.Collections.Generic,
  {$ENDIF CLR}
  JclAlgorithms,
  {$ENDIF SUPPORTS_GENERICS}
  JclBase, JclAbstractContainers, JclContainerIntf;
{$I Containers\JclArrayLists.imp}
type
{$JPPEXPANDMACRO JCLARRAYLISTINT(TJclIntfArrayList,TJclIntfContainer,IJclIntfCollection,IJclIntfList,IJclIntfArray,IJclIntfIterator,JclBase.TDynIInterfaceArray, IJclContainer\, IJclIntfEqualityComparer\,,,
    function CreateEmptyContainer: TJclAbstractContainer; override;,,,,const AInterface: IInterface,IInterface,GetObject,SetObject)}

{$JPPEXPANDMACRO JCLARRAYLISTINT(TJclStrArrayList,TJclStrAbstractCollection,IJclStrCollection,IJclStrList,IJclStrArray,IJclStrIterator,JclBase.TDynStringArray, IJclContainer\, IJclStrContainer\, IJclStrFlatContainer\, IJclStrEqualityComparer\,,,
    function CreateEmptyContainer: TJclAbstractContainer; override;,, override;,,const AString: string,string,GetString,SetString)}

{$JPPEXPANDMACRO JCLARRAYLISTINT(TJclArrayList,TJclContainer,IJclCollection,IJclList,IJclArray,IJclIterator,JclBase.TDynObjectArray, IJclContainer\, IJclObjectOwner\, IJclEqualityComparer\,,,
    function CreateEmptyContainer: TJclAbstractContainer; override;,,,; AOwnsObjects: Boolean,AObject: TObject,TObject,GetObject,SetObject)}

  {$IFDEF SUPPORTS_GENERICS}
{$JPPEXPANDMACRO JCLARRAYLISTINT(TJclArrayList<T>,TJclContainer<T>,IJclCollection<T>,IJclList<T>,IJclArray<T>,IJclIterator<T>,TJclBase<T>.TDynArray, IJclContainer\, IJclItemOwner<T>\, IJclEqualityComparer<T>\,,,,,,; AOwnsItems: Boolean,const AItem: T,T,GetItem,SetItem)}

  // E = External helper to compare items for equality
  // GetHashCode is not used
  TJclArrayListE<T> = class(TJclArrayList<T>, IJclCollection<T>, IJclList<T>, IJclArray<T>, IJclContainer, IJclItemOwner<T>, IJclEqualityComparer<T>,
    {$IFDEF THREADSAFE} IJclLockable, {$ENDIF THREADSAFE} IJclIntfCloneable, IJclCloneable, IJclPackable, IJclGrowable)
  private
    FEqualityComparer: IEqualityComparer<T>;
  protected
    procedure AssignPropertiesTo(Dest: TJclAbstractContainer); override;
    function ItemsEqual(const A, B: T): Boolean; override;
    function CreateEmptyContainer: TJclAbstractContainer; override;
    { IJclIntfCloneable }
    function IJclIntfCloneable.Clone = IntfClone;
  public
    constructor Create(const AEqualityComparer: IEqualityComparer<T>; ACapacity: Integer; AOwnsItems: Boolean); overload;
    constructor Create(const AEqualityComparer: IEqualityComparer<T>; const ACollection: IJclCollection<T>; AOwnsItems: Boolean); overload;

    property EqualityComparer: IEqualityComparer<T> read FEqualityComparer write FEqualityComparer;
  end;

  // F = Function to compare items for equality
  TJclArrayListF<T> = class(TJclArrayList<T>, IJclCollection<T>, IJclList<T>, IJclArray<T>, IJclContainer, IJclItemOwner<T>, IJclEqualityComparer<T>,
    {$IFDEF THREADSAFE} IJclLockable, {$ENDIF THREADSAFE} IJclIntfCloneable, IJclCloneable, IJclPackable, IJclGrowable)
  private
    FEqualityCompare: TEqualityCompare<T>;
  protected
    procedure AssignPropertiesTo(Dest: TJclAbstractContainer); override;
    function ItemsEqual(const A, B: T): Boolean; override;
    function CreateEmptyContainer: TJclAbstractContainer; override;
    { IJclIntfCloneable }
    function IJclIntfCloneable.Clone = IntfClone;
  public
    constructor Create(const AEqualityCompare: TEqualityCompare<T>; ACapacity: Integer; AOwnsItems: Boolean); overload;
    constructor Create(const AEqualityCompare: TEqualityCompare<T>; const ACollection: IJclCollection<T>; AOwnsItems: Boolean); overload;

    property EqualityCompare: TEqualityCompare<T> read FEqualityCompare write FEqualityCompare;
  end;

  // I = Items can compare themselves to others
  TJclArrayListI<T: IEquatable<T>> = class(TJclArrayList<T>, IJclCollection<T>, IJclList<T>, IJclArray<T>, IJclContainer, IJclItemOwner<T>, IJclEqualityComparer<T>,
    {$IFDEF THREADSAFE} IJclLockable, {$ENDIF THREADSAFE} IJclIntfCloneable, IJclCloneable, IJclPackable, IJclGrowable)
  protected
    function ItemsEqual(const A, B: T): Boolean; override;
    function CreateEmptyContainer: TJclAbstractContainer; override;
    { IJclIntfCloneable }
    function IJclIntfCloneable.Clone = IntfClone;
  end;

  {$ENDIF SUPPORTS_GENERICS}

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL$';
    Revision: '$Revision$';
    Date: '$Date$';
    LogPath: 'JCL\source\common'
    );
{$ENDIF UNITVERSIONING}

implementation

uses
  SysUtils;

{$JPPEXPANDMACRO JCLARRAYLISTITR(TIntfItr,IJclIntfIterator,IJclIntfList,const AInterface: IInterface,AInterface,IInterface,GetObject,SetObject)}
{$JPPEXPANDMACRO JCLARRAYLISTITR(TStrItr,IJclStrIterator,IJclStrList,const AString: string,AString,string,GetString,SetString)}
{$JPPEXPANDMACRO JCLARRAYLISTITR(TItr,IJclIterator,IJclList,AObject: TObject,AObject,TObject,GetObject,SetObject)}

{$IFDEF SUPPORTS_GENERICS}
{$JPPEXPANDMACRO JCLARRAYLISTITR(TItr<T>,IJclIterator<T>,IJclList<T>,const AItem: T,AItem,T,GetItem,SetItem)}
{$ENDIF SUPPORTS_GENERICS}

{$JPPDEFINEMACRO CREATEEMPTYCONTAINER
function TJclIntfArrayList.CreateEmptyContainer: TJclAbstractContainer;
begin
  Result := TJclIntfArrayList.Create(FSize);
  AssignPropertiesTo(Result);
end;
}
{$JPPEXPANDMACRO JCLARRAYLISTIMP(TJclIntfArrayList,,,IJclIntfCollection,IJclIntfIterator,TIntfItr,IJclIntfList,const AInterface: IInterface,AInterface,GetObject,SetObject,FreeObject,IInterface,nil,JclBase.MoveArray)}
{$JPPUNDEFMACRO CREATEEMPTYCONTAINER}

{$JPPDEFINEMACRO CREATEEMPTYCONTAINER
function TJclStrArrayList.CreateEmptyContainer: TJclAbstractContainer;
begin
  Result := TJclStrArrayList.Create(FSize);
  AssignPropertiesTo(Result);
end;
}
{$JPPEXPANDMACRO JCLARRAYLISTIMP(TJclStrArrayList,,,IJclStrCollection,IJclStrIterator,TStrItr,IJclStrList,const AString: string,AString,GetString,SetString,FreeString,string,'',JclBase.MoveArray)}
{$JPPUNDEFMACRO CREATEEMPTYCONTAINER}

{$JPPDEFINEMACRO CREATEEMPTYCONTAINER
function TJclArrayList.CreateEmptyContainer: TJclAbstractContainer;
begin
  Result := TJclArrayList.Create(FSize, False);
  AssignPropertiesTo(Result);
end;
}
{$JPPEXPANDMACRO JCLARRAYLISTIMP(TJclArrayList,; AOwnsObjects: Boolean,\, AOwnsObjects,IJclCollection,IJclIterator,TItr,IJclList,AObject: TObject,AObject,GetObject,SetObject,FreeObject,TObject,nil,JclBase.MoveArray)}
{$JPPUNDEFMACRO CREATEEMPTYCONTAINER}

{$IFDEF SUPPORTS_GENERICS}
{$JPPDEFINEMACRO CREATEEMPTYCONTAINER}
{$JPPEXPANDMACRO JCLARRAYLISTIMP(TJclArrayList<T>,; AOwnsItems: Boolean,\, AOwnsItems,IJclCollection<T>,IJclIterator<T>,TItr<T>,IJclList<T>,const AItem: T,AItem,GetItem,SetItem,FreeItem,T,Default(T),TJclBase<T>.MoveArray)}
{$JPPUNDEFMACRO CREATEEMPTYCONTAINER}

//=== { TJclArrayListE<T> } ==================================================

constructor TJclArrayListE<T>.Create(const AEqualityComparer: IEqualityComparer<T>; ACapacity: Integer;
  AOwnsItems: Boolean);
begin
  inherited Create(ACapacity, AOwnsItems);
  FEqualityComparer := AEqualityComparer;
end;

constructor TJclArrayListE<T>.Create(const AEqualityComparer: IEqualityComparer<T>;
  const ACollection: IJclCollection<T>; AOwnsItems: Boolean);
begin
  inherited Create(ACollection, AOwnsItems);
  FEqualityComparer := AEqualityComparer;
end;

procedure TJclArrayListE<T>.AssignPropertiesTo(Dest: TJclAbstractContainer);
begin
  inherited AssignPropertiesTo(Dest);
  if Dest is TJclArrayListE<T> then
    TJclArrayListE<T>(Dest).FEqualityComparer := FEqualityComparer;
end;

function TJclArrayListE<T>.CreateEmptyContainer: TJclAbstractContainer;
begin
  Result := TJclArrayListE<T>.Create(EqualityComparer, FSize, False);
  AssignPropertiesTo(Result);
end;

function TJclArrayListE<T>.ItemsEqual(const A, B: T): Boolean;
begin
  if EqualityComparer = nil then
    raise EJclNoEqualityComparerError.Create;
  Result := EqualityComparer.Equals(A, B);
end;

//=== { TJclArrayListF<T> } ==================================================

constructor TJclArrayListF<T>.Create(const AEqualityCompare: TEqualityCompare<T>;
  ACapacity: Integer; AOwnsItems: Boolean);
begin
  inherited Create(ACapacity, AOwnsItems);
  FEqualityCompare := AEqualityCompare;
end;

constructor TJclArrayListF<T>.Create(const AEqualityCompare: TEqualityCompare<T>; const ACollection: IJclCollection<T>;
  AOwnsItems: Boolean);
begin
  inherited Create(ACollection, AOwnsItems);
  FEqualityCompare := AEqualityCompare;
end;

procedure TJclArrayListF<T>.AssignPropertiesTo(Dest: TJclAbstractContainer);
begin
  inherited AssignPropertiesTo(Dest);
  if Dest is TJclArrayListF<T> then
    TJclArrayListF<T>(Dest).FEqualityCompare := FEqualityCompare;
end;

function TJclArrayListF<T>.CreateEmptyContainer: TJclAbstractContainer;
begin
  Result := TJclArrayListF<T>.Create(EqualityCompare, FSize, False);
  AssignPropertiesTo(Result);
end;

function TJclArrayListF<T>.ItemsEqual(const A, B: T): Boolean;
begin
  if not Assigned(EqualityCompare) then
    raise EJclNoEqualityComparerError.Create;
  Result := EqualityCompare(A, B);
end;

//=== { TJclArrayListI<T> } ==================================================

function TJclArrayListI<T>.ItemsEqual(const A, B: T): Boolean;
begin
  Result := A.Equals(B);
end;

function TJclArrayListI<T>.CreateEmptyContainer: TJclAbstractContainer;
begin
  Result := TJclArrayListI<T>.Create(FSize, False);
  AssignPropertiesTo(Result);
end;

{$ENDIF SUPPORTS_GENERICS}

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

