contract AlbumList
{
    function StructSerialization()
    {
    }
    event EventoStructAlbum(uint32 id, string name);
    //Use only fixed size simple (uint,int) types!
    struct Album
    {
        uint id;
        string album_name;
        string playlist;
        string records_date; 
        string song_styles; 
        string release_date;
        string purchase_link;
    }
    function MostrarAlbum(Album u) private
    {
        EventoStructAlbum(
            u.id, 
            u.album_name,
            u.playlist, 
            u.records_date, 
            u.song_styles, 
            u.release_date, 
            u.purchase_link);
    }
    function ConverterAlbumPraBytes(Album u) private
    returns (bytes data)
    {
        uint _size = 7 + bytes(u.id).length;
        //7 ids das structs
        bytes memory _data = new bytes(_size);

        uint counter=0;
        for (uint i=0;i<4;i++)
        {
            _data[counter]=byte(u.id>>(8*i)&uint32(255));
            counter++;
        }

        for (i=0;i<bytes(u.id).length;i++)
        {
            _data[counter]=bytes(u.id)[i];
            counter++;
        }

        return (_data);
    }
    function AlbumStructsEmBytes(bytes data) private
    returns (Album u)
    {
        for (uint i=0;i<4;i++)
        {
            uint32 temp = uint32(data[i]);
            temp<<=8*i;
            u.id^=temp;
        }
        bytes memory str = new bytes(data.length-4);
        for (i=0;i<data.length-4;i++)
        {
            str[i]=data[i+4];
        }
        u.name=string(str);
     }

    function test()
    {
        //Create and  show struct
        Album memory album_struct1 = Album(1,"LinkinPark","Meteora","12/10/2018","Rock","12/11/2019","link");
        MostrarAlbum(album_struct1);
        //Serializing struct
        bytes memory serialized_album_struct1 = ConverterAlbumPraBytes(album_struct1);
        //Deserializing struct
        Album memory album_struct2 = AlbumStructsEmBytes(serialized_album_struct1);
        //Show deserealized struct
        MostrarAlbum(album_struct2);
    }
}
