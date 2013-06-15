using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;

namespace LevelEditor
{  
  
    public class MapEditor
    {

        const int one = 8, two = -16, three = 1;

        int SCROLLING_SPEED;
        const int SCROLL_SPEED_BASE = 10; 
        private List<Vector2> mTilePositions;
        Texture2D mTempTexture;
        Vector2 mTempVector2;
        int mTileHeightNumber, mTileWidthNumber, mTileSize, newOrLoad, mNumberOfPlaceableTiles;
        string mReadInString, mTempString, mFileName, mTextureFilename;
        StreamWriter output;
        StreamReader mFileRead;
        int mMouseWheelPos;

        Texture2D mSpriteSheet;
        Texture2D mTransparentTile;
        Texture2D mPlayerUnitTile;
        List<Rectangle> mTileSourceRectangles;
        List<int> mTileNumber;
        int mCurrentTile;
        int mTilesVert;
        int mTilesHorz;
        int mCurrentVert;
        int mCurrentHorz;
        int xOffSet;
        int yOffSet;
        int manMode;

        string[] mSplitFile;

        //for unit placing
        bool spaceDown;
        int mCurrentUnit, mPlaceableUnitCount;
        string mUnitFilename, mUnitLoadFilename;
        Texture2D mUnitSpriteSheet;
        List<Rectangle> mUnitSourceRectangles;
        List<Vector2> mPlacedUnitPositions;
        List<int> mPlacedUnitNumbers;


        //for obstacle placing
        int mCurrentObstacle, mPlaceableObstacleCount;
        string mObstacleFilename;
        Texture2D mObstacleSpriteSheet;
        List<Rectangle> mObstacleSourceRectangles;
        List<Vector2> mPlacedObstaclePositions;
        List<int> mPlacedObstacleNumbers;
        

        public MapEditor()
        {
         
            mTilePositions = new List<Vector2>();

            mTileSourceRectangles = new List<Rectangle>();
            mTileNumber = new List<int>();
            mUnitSourceRectangles = new List<Rectangle>();
           
            mPlacedUnitNumbers = new List<int>();
            mPlacedUnitPositions = new List<Vector2>();
            mObstacleSourceRectangles = new List<Rectangle>();
            mPlacedObstacleNumbers = new List<int>();
            mPlacedObstaclePositions = new List<Vector2>();

            mMouseWheelPos = Mouse.GetState().ScrollWheelValue;
            mCurrentTile = 0;
            mCurrentVert = 0;
            mCurrentHorz = 0;
            mCurrentUnit = 1;
            mCurrentObstacle = 1;
            yOffSet = 0;
            xOffSet = 0;
            spaceDown = false;
            manMode = 0;
            SCROLLING_SPEED = SCROLL_SPEED_BASE;
            //mUnitLoadFilename = "unitDataDriven.txt";
           
            mFileRead = new StreamReader("dataDriven.txt");
            dataDriven();
            
        }

        public void init()
        {

            if (newOrLoad == 0)
                readInFile();
            else
                createNewMap();

        }

        public void loadContent(ContentManager content)
        {
           
            mTransparentTile = content.Load<Texture2D>("transparentTile");
            mPlayerUnitTile = content.Load<Texture2D>("playerObject");

            mSpriteSheet = content.Load<Texture2D>(mTextureFilename);
            for (int i = 0; i < (mSpriteSheet.Height / mTileSize); i++)
            {
                for (int j = 0; j < (mSpriteSheet.Width / mTileSize); j++)
                {
                    mTileSourceRectangles.Add(new Rectangle(j * mTileSize, i * mTileSize, mTileSize, mTileSize));
                }
            }

           mTilesHorz = (mSpriteSheet.Width / mTileSize);
           mTilesVert = (mSpriteSheet.Height / mTileSize);

            mUnitSpriteSheet = content.Load<Texture2D>(mUnitFilename);
            for (int i = 0; i < (mUnitSpriteSheet.Height / mTileSize); i++)
            {
                for (int j = 0; j < (mUnitSpriteSheet.Width / mTileSize); j++)
                {
                    mUnitSourceRectangles.Add(new Rectangle(j * mTileSize, i * mTileSize, mTileSize, mTileSize));
                }
            }

            mObstacleSpriteSheet = content.Load<Texture2D>(mObstacleFilename);
            for (int i = 0; i < (mObstacleSpriteSheet.Height / mTileSize); i++)
            {
                for (int j = 0; j < (mObstacleSpriteSheet.Width / mTileSize); j++)
                {
                    mObstacleSourceRectangles.Add(new Rectangle(j * mTileSize, i * mTileSize, mTileSize, mTileSize));
                }
            }
        }

        private void readInFile()
        {
            mFileRead = new StreamReader(mFileName);

            int tempInt = 0;

            for (int i = 0; i < mTileHeightNumber; i++)
            {
                for (int j = 0; j < mTileWidthNumber; j++)
                {
                    
                    tempInt = mFileRead.Read() - 48;
                    mReadInString = tempInt.ToString();
                    tempInt = mFileRead.Read() - 48;
                    mReadInString += tempInt.ToString();
                    tempInt = mFileRead.Read();
                    if (tempInt == 44)
                    {
                        for (int k = j; j < mTileWidthNumber - 1; j++)
                        {
                            mTileNumber.Add(-1);
                            mTilePositions.Add(new Vector2(j * mTileSize, i * mTileSize));
                        }
                        mFileRead.ReadLine();
                    }
                    if( mReadInString == "-31")
                    {
                        mReadInString = "-1";
                    }
                    
                    mTileNumber.Add(Convert.ToInt32(mReadInString));
                    mTilePositions.Add(new Vector2(j * mTileSize, i * mTileSize));
                }
                if (tempInt != 44)
                {
                    mFileRead.ReadLine();
                }
               
            }
            mFileRead.Close();

            mFileRead = new StreamReader(mUnitLoadFilename);

            mReadInString = mFileRead.ReadLine();

            while (mReadInString != "end")
            {
                if (mReadInString == "PLAYERINFO")
                {
                    mSplitFile = mFileRead.ReadLine().Split(' ');

                    Vector2 tempVector;
                    tempVector.X = Convert.ToInt32(mSplitFile[0]) * mTileSize;
                    tempVector.Y = Convert.ToInt32(mSplitFile[1]) * mTileSize;

                    mPlacedUnitPositions.Add(tempVector);
                    mPlacedUnitNumbers.Add(-1);

                }
                if (mReadInString == "UNIT")
                {
                    mSplitFile = mFileRead.ReadLine().Split(' ');

                   /* if (mReadInString == "-31")
                    {
                        mReadInString = "-1";
                    }*/

                    mPlacedUnitNumbers.Add(Convert.ToInt32(mSplitFile[0]));

                    Vector2 tempVector;
                   

                    tempVector.X = Convert.ToInt32(mSplitFile[1]) * mTileSize;
                    tempVector.Y = Convert.ToInt32(mSplitFile[2]) * mTileSize;

                    mPlacedUnitPositions.Add(tempVector);
                }
                else if (mReadInString == "OBSTACLE")
                {
                    mSplitFile = mFileRead.ReadLine().Split(' ');

                    mPlacedObstacleNumbers.Add(Convert.ToInt32(mSplitFile[0]));

                    Vector2 tempVector;


                    tempVector.X = Convert.ToInt32(mSplitFile[1]) * mTileSize;
                    tempVector.Y = Convert.ToInt32(mSplitFile[2]) * mTileSize;

                    mPlacedObstaclePositions.Add(tempVector);
                }
               
                mReadInString = mFileRead.ReadLine();
            }
            mFileRead.Close();
        }

        private void outputToFile()
        {
            int tempInt, tempInt2;
            string tempString;
            output = new StreamWriter(new FileStream(mFileName, FileMode.Create, FileAccess.Write));
            
            for (int i = 0; i < mTileHeightNumber; i++)
            {
                mTempString = "";
                for (int j = 0; j < mTileWidthNumber; j++)
                {  
                    int k = i * mTileWidthNumber + j;
                    k = mTileNumber[k];
                    if (j == 0)
                    {
                        if (k < 10 && k != -1)
                            mTempString += ("0" + k);
                        else
                            mTempString += (k);
                    }
                    else if (j > 0)
                    {
                        if (k < 10 && k != -1)
                            mTempString += (" 0" + k);
                        else
                            mTempString += (" " + k);
                    }
                }
                mTempString += ",";
                output.WriteLine(mTempString);
            }
            output.WriteLine("e " + mTextureFilename[mTextureFilename.Length - 1]);
            output.Close();
            output = new StreamWriter(new FileStream(mUnitLoadFilename, FileMode.Create, FileAccess.Write));
            
            for (int i = 0; i < mPlacedUnitNumbers.Count; i++)
            {
                if (mPlacedUnitNumbers[i] == -1)
                {
                    output.WriteLine("PLAYERINFO");
                    string tempOutput1, tempOutput2;
                    if ((mPlacedUnitPositions[i].X - xOffSet) / mTileSize < 10)
                        tempOutput1 = "0" + (mPlacedUnitPositions[i].X - xOffSet) / mTileSize;
                    else
                        tempOutput1 = "" + (mPlacedUnitPositions[i].X - xOffSet) / mTileSize;
                    if ((mPlacedUnitPositions[i].Y - yOffSet) / mTileSize < 10)
                        tempOutput2 = "0" + (mPlacedUnitPositions[i].Y - yOffSet) / mTileSize;
                    else
                        tempOutput2 = "" + (mPlacedUnitPositions[i].Y - yOffSet) / mTileSize;
                    output.WriteLine(tempOutput1 + " " + tempOutput2 + " " + one + " " + two + " " + three);
                }
            }
            for (int i = 0; i < mPlacedUnitNumbers.Count; i++)
            {
                if (mPlacedUnitNumbers[i] != -1)
                {
                    output.WriteLine("UNIT");
                    tempInt = ((int)mPlacedUnitPositions[i].X - xOffSet) / mTileSize;
                    tempInt2 = ((int)mPlacedUnitPositions[i].Y - yOffSet) / mTileSize;
                    if (mPlacedUnitNumbers[i] < 10 && mPlacedUnitNumbers[i] != -1)
                        tempString = "0" + mPlacedUnitNumbers[i];
                    else
                        tempString = "" + mPlacedUnitNumbers[i];

                    if (tempInt < 10)
                        tempString += " 0" + tempInt;
                    else
                        tempString += " " + tempInt;

                    if (tempInt2 < 10)
                        tempString += " 0" + tempInt2;
                    else
                        tempString += " " + tempInt2;

                    output.WriteLine(tempString);
                }
            }

            for (int i = 0; i < mPlacedObstacleNumbers.Count; i++)
            {
                output.WriteLine("OBSTACLE");
                tempInt = ((int)mPlacedObstaclePositions[i].X - xOffSet) / mTileSize;
                tempInt2 = ((int)mPlacedObstaclePositions[i].Y - yOffSet) / mTileSize;
                if (mPlacedObstacleNumbers[i] < 10)
                    tempString = "0" + mPlacedObstacleNumbers[i];
                else
                    tempString = "" + mPlacedObstacleNumbers[i];

                if (tempInt < 10)
                    tempString += " 0" + tempInt;
                else
                    tempString += " " + tempInt;

                if (tempInt2 < 10)
                    tempString += " 0" + tempInt2;
                else
                    tempString += " " + tempInt2;

                output.WriteLine(tempString);
            }
            output.WriteLine("end");
            output.Close();
        }

        private void createNewMap()
        {
            for (int i = 0; i < mTileHeightNumber; i++)
            {
                for (int j = 0; j < mTileWidthNumber; j++)
                {
                    mTileNumber.Add(-1);
                    mTilePositions.Add(new Vector2(j * mTileSize, i * mTileSize));
                }
            }
        }

        private void dataDriven()
        {
            mReadInString = mFileRead.ReadLine();
            while (mReadInString != "end")
            {
                if (mReadInString == "mapFileName") 
                {
                    mFileName = mFileRead.ReadLine();
                }
                else if (mReadInString == "numberOfTiles")
                {
                    mNumberOfPlaceableTiles = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "tileSize")
                {
                    mTileSize = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "tileWidthNumber")
                {
                    mTileWidthNumber = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "tileHeightNumber")
                {
                    mTileHeightNumber = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "new")
                {
                    newOrLoad = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "-")
                {
                    //emptyLine
                }
                else if (mReadInString == "spritesheet name")
                {
                    mTextureFilename = mFileRead.ReadLine();
                }
                else if (mReadInString == "unit spritesheet name")
                {
                    mUnitFilename = mFileRead.ReadLine();
                }
                else if (mReadInString == "number of placeable units")
                {
                    mPlaceableUnitCount = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "obstacle spritesheet name")
                {
                    mObstacleFilename = mFileRead.ReadLine();
                }
                else if (mReadInString == "number of placeable obstacle")
                {
                    mPlaceableObstacleCount = Convert.ToInt32(mFileRead.ReadLine());
                }
                else if (mReadInString == "unit data driven filename")
                {
                    mUnitLoadFilename = mFileRead.ReadLine();
                }
                else
                {
                    Console.WriteLine("ya done goofed");
                    Console.Beep();
                }

                mReadInString = mFileRead.ReadLine();
            }
            mFileRead.Close();
        }

        public void draw(SpriteBatch spritebatch)
        {
            for (int i = 0; i < mTileNumber.Count; i++)
            {
                
                if (containsMousePoint(mTilePositions[i]))
                {
                    if (manMode == 0)
                    {
                        if (mCurrentTile == -1)
                        {
                            spritebatch.Draw(mTransparentTile, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), Color.White);
                        }
                        else
                            spritebatch.Draw(mSpriteSheet, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), mTileSourceRectangles[mCurrentTile], Color.White);
                    }
                    else if( manMode == 1)
                    {
                        if (mTileNumber[i] == -1)
                           spritebatch.Draw(mTransparentTile, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), Color.White);
                        else
                            spritebatch.Draw(mSpriteSheet, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), mTileSourceRectangles[mTileNumber[i]], Color.White);
                        if (mCurrentUnit > -1)
                            spritebatch.Draw(mUnitSpriteSheet, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), mUnitSourceRectangles[mCurrentUnit], Color.White);
                        else
                            spritebatch.Draw(mPlayerUnitTile, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), Color.White);
                    }
                    else if (manMode == 2)
                    {
                        if (mTileNumber[i] == -1)
                        {
                            spritebatch.Draw(mTransparentTile, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), Color.White);
                        }
                        else
                            spritebatch.Draw(mSpriteSheet, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), mTileSourceRectangles[mTileNumber[i]], Color.White);

                        spritebatch.Draw(mObstacleSpriteSheet, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), mUnitSourceRectangles[mCurrentObstacle], Color.White);
                    }
                }
                else
                {
                    if (mTileNumber[i] == -1)
                    {
                        spritebatch.Draw(mTransparentTile, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), Color.White);
                    }
                    else
                        spritebatch.Draw(mSpriteSheet, new Vector2(mTilePositions[i].X, mTilePositions[i].Y), mTileSourceRectangles[mTileNumber[i]], Color.White);
                }
            }
           
            for (int i = 0; i < mPlacedUnitNumbers.Count; i++)
            {
                if( !containsMousePoint(mPlacedUnitPositions[i]))
                    if( mPlacedUnitNumbers[i] != -1)
                        spritebatch.Draw(mUnitSpriteSheet, new Vector2(mPlacedUnitPositions[i].X, mPlacedUnitPositions[i].Y), mUnitSourceRectangles[mPlacedUnitNumbers[i]], Color.White);
                    else
                        spritebatch.Draw(mPlayerUnitTile, new Vector2(mPlacedUnitPositions[i].X, mPlacedUnitPositions[i].Y), Color.White);
            }
            for (int i = 0; i < mPlacedObstacleNumbers.Count; i++)
            {
                if (!containsMousePoint(mPlacedObstaclePositions[i]))
                    spritebatch.Draw(mObstacleSpriteSheet, new Vector2(mPlacedObstaclePositions[i].X, mPlacedObstaclePositions[i].Y), mObstacleSourceRectangles[mPlacedObstacleNumbers[i]], Color.White);
            }
        }

        public bool update()
        {

            if( Keyboard.GetState().IsKeyDown(Keys.LeftShift) || Keyboard.GetState().IsKeyDown(Keys.RightShift))
                SCROLLING_SPEED *= 3;

            if (Mouse.GetState().LeftButton == ButtonState.Pressed)
            {
                if (manMode == 0)
                {
                    for (int i = 0; i < mTileNumber.Count; i++)
                    {
                        if (containsMousePoint(mTilePositions[i]))
                        {
                            mTileNumber[i] = mCurrentTile;
                        }
                    }
                }
                else if( manMode == 1)
                {
                    bool unitPlaced = false;
                    for (int i = 0; i < mTileNumber.Count; i++)
                    {
                        if (containsMousePoint(mTilePositions[i]))
                        {
                            if (mCurrentUnit == -1)
                            {
                                for (int j = 0; j < mPlacedUnitNumbers.Count; j++)
                                {
                                    if (mPlacedUnitNumbers[j] == -1)
                                    {
                                        mPlacedUnitPositions[j] = mTilePositions[i];
                                        unitPlaced = true;
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                for (int j = 0; j < mPlacedUnitNumbers.Count; j++)
                                {
                                    if (mTilePositions[i] == mPlacedUnitPositions[j])
                                    {
                                        mPlacedUnitNumbers[j] = mCurrentUnit;
                                        unitPlaced = true;
                                        break;
                                    }
                                }
                            }
                            if (!unitPlaced)
                            {
                                mPlacedUnitPositions.Add(mTilePositions[i]);
                                mPlacedUnitNumbers.Add(mCurrentUnit);
                            }
                            
                        }
                    }
                }
                else if (manMode == 2)
                {
                    bool obstaclePlaced = false;
                    for (int i = 0; i < mTileNumber.Count; i++)
                    {
                        if (containsMousePoint(mTilePositions[i]))
                        {
                            for (int j = 0; j < mPlacedObstacleNumbers.Count; j++)
                            {
                                if (mTilePositions[i] == mPlacedObstaclePositions[j])
                                {
                                    mPlacedObstacleNumbers[j] = mCurrentObstacle;
                                    obstaclePlaced = true;
                                    break;
                                }
                            }
                            if (!obstaclePlaced)
                            {
                                mPlacedObstaclePositions.Add(mTilePositions[i]);
                                mPlacedObstacleNumbers.Add(mCurrentObstacle);
                            }
                        }
                    }
                }
            }
            else if (Mouse.GetState().RightButton == ButtonState.Pressed)
            {
                if (manMode == 0)
                {
                    for (int i = 0; i < mTileNumber.Count; i++)
                    {
                        if (containsMousePoint(mTilePositions[i]))
                        {
                            mTileNumber[i] = -1;
                            break;
                        }
                    }
                }
                else if (manMode == 1)
                {
                    for (int i = 0; i < mPlacedUnitNumbers.Count; i++)
                    {
                        if (containsMousePoint(mPlacedUnitPositions[i]))
                        {
                            mPlacedUnitPositions.RemoveAt(i);
                            mPlacedUnitNumbers.RemoveAt(i);
                            break;
                        }
                    }
                }
                else if (manMode == 2)
                {
                    for (int i = 0; i < mPlacedObstacleNumbers.Count; i++)
                    {
                        if (containsMousePoint(mPlacedObstaclePositions[i]))
                        {
                            mPlacedObstaclePositions.RemoveAt(i);
                            mPlacedObstacleNumbers.RemoveAt(i);
                            break;
                        }
                    }
                }
            }
            else if (Keyboard.GetState().IsKeyDown(Keys.Space) && spaceDown == false)
            {
                spaceDown = true;
            }
            else if (Keyboard.GetState().IsKeyUp(Keys.Space) && spaceDown == true)
            {
                if (manMode == 0)
                    manMode = 1;
                else if (manMode == 1)
                    manMode = 2;
                else if (manMode == 2)
                    manMode = 0;
                spaceDown = false;
            }

            if (Mouse.GetState().ScrollWheelValue < mMouseWheelPos)
            {
                mMouseWheelPos = Mouse.GetState().ScrollWheelValue;
                if (manMode == 0)
                {
                    if (mCurrentVert > 0)
                    {
                        mCurrentVert--;
                        mCurrentTile = mCurrentVert * mTilesHorz + mCurrentHorz;
                    }
                    else
                    {
                        if (mCurrentTile != 00)
                        {
                            mCurrentHorz--;
                            mCurrentVert = mTilesVert - 1;
                            mCurrentTile = mCurrentVert * mTilesHorz + mCurrentHorz;
                            if (mCurrentHorz < 0)
                            {
                                mCurrentHorz = mTilesHorz;
                                mCurrentTile = -1;
                                mCurrentVert = -1;
                            }
                        }
                        else
                        {
                            mCurrentHorz--;
                            mCurrentVert = mTilesVert - 1;
                            mCurrentTile = mCurrentVert * mTilesHorz + mCurrentHorz;
                            mCurrentHorz = mTilesHorz;
                            mCurrentTile = -1;
                            mCurrentVert = -1;
                        }

                    }

                }
                else if( manMode == 1)
                {
                    if (mCurrentUnit > -1)
                        mCurrentUnit--;
                    else if (mCurrentUnit == -1)
                        mCurrentUnit = mPlaceableUnitCount - 1;
                }
                else if (manMode == 2)
                {
                    if (mCurrentObstacle > 0)
                        mCurrentObstacle--;
                    else if (mCurrentObstacle == 0)
                        mCurrentObstacle = mPlaceableObstacleCount - 1;
                }
            }
            else if (Mouse.GetState().ScrollWheelValue > mMouseWheelPos)
            {
                mMouseWheelPos = Mouse.GetState().ScrollWheelValue;
                if (manMode == 0)
                {
                    if (mCurrentVert < mTilesVert - 1)
                    {
                        if (mCurrentTile == -1)
                        {
                            mCurrentVert++;
                            mCurrentTile = mCurrentVert * mTilesHorz;
                        }
                        else
                        {
                            mCurrentVert++;
                            mCurrentTile = mCurrentVert * mTilesHorz + mCurrentHorz;
                        }
                    }
                    else
                    {
                        mCurrentHorz++;
                        mCurrentVert = 0;
                        mCurrentTile = mCurrentVert * mTilesHorz + mCurrentHorz;
                        if (mCurrentHorz >= mTilesHorz)
                        {
                            mCurrentHorz = 0;
                            mCurrentTile = -1;
                            mCurrentVert = -1;
                        }
                    }
                    if (mCurrentTile == 28)
                        mCurrentTile = 27;
                }
                else if( manMode == 1)
                {
                    if (mCurrentUnit < mPlaceableUnitCount - 1)
                        mCurrentUnit++;
                    else if (mCurrentUnit == mPlaceableUnitCount - 1)
                        mCurrentUnit = -1;
                }
                else if (manMode == 2)
                {
                    if (mCurrentObstacle < mPlaceableObstacleCount - 1)
                        mCurrentObstacle++;
                    else if (mCurrentObstacle == mPlaceableObstacleCount - 1)
                        mCurrentObstacle = 0;
                }
            }

            if (Keyboard.GetState().IsKeyDown(Keys.D) == true)
            {
                xOffSet -= SCROLLING_SPEED;
                for (int i = 0; i < mTileNumber.Count; i++)
                {
                    mTempVector2 = mTilePositions[i];
                    mTempVector2.X -= SCROLLING_SPEED;
                    mTilePositions[i] = mTempVector2;
                    
                }
                for (int i = 0; i < mPlacedUnitPositions.Count; i++)
                {
                    mTempVector2 = mPlacedUnitPositions[i];
                    mTempVector2.X -= SCROLLING_SPEED;
                    mPlacedUnitPositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedObstaclePositions.Count; i++)
                {
                    mTempVector2 = mPlacedObstaclePositions[i];
                    mTempVector2.X -= SCROLLING_SPEED;
                    mPlacedObstaclePositions[i] = mTempVector2;
                }
            }
            if (Keyboard.GetState().IsKeyDown(Keys.W) == true)
            {
                yOffSet += SCROLLING_SPEED;
                for (int i = 0; i < mTileNumber.Count; i++)
                {
                    mTempVector2 = mTilePositions[i];
                    mTempVector2.Y += SCROLLING_SPEED;
                    mTilePositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedUnitPositions.Count; i++)
                {
                    mTempVector2 = mPlacedUnitPositions[i];
                    mTempVector2.Y += SCROLLING_SPEED;
                    mPlacedUnitPositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedObstaclePositions.Count; i++)
                {
                    mTempVector2 = mPlacedObstaclePositions[i];
                    mTempVector2.Y += SCROLLING_SPEED;
                    mPlacedObstaclePositions[i] = mTempVector2;
                }
            }
            if (Keyboard.GetState().IsKeyDown(Keys.S) == true)
            {
                yOffSet -= SCROLLING_SPEED;
                for (int i = 0; i < mTileNumber.Count; i++)
                {
                    mTempVector2 = mTilePositions[i];
                    mTempVector2.Y -= SCROLLING_SPEED;
                    mTilePositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedUnitPositions.Count; i++)
                {
                    mTempVector2 = mPlacedUnitPositions[i];
                    mTempVector2.Y -= SCROLLING_SPEED;
                    mPlacedUnitPositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedObstaclePositions.Count; i++)
                {
                    mTempVector2 = mPlacedObstaclePositions[i];
                    mTempVector2.Y -= SCROLLING_SPEED;
                    mPlacedObstaclePositions[i] = mTempVector2;
                }
            }
            if (Keyboard.GetState().IsKeyDown(Keys.A) == true)
            {
                xOffSet += SCROLLING_SPEED;
                for (int i = 0; i < mTileNumber.Count; i++)
                {
                    mTempVector2 = mTilePositions[i];
                    mTempVector2.X += SCROLLING_SPEED;
                    mTilePositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedUnitPositions.Count; i++)
                {
                    mTempVector2 = mPlacedUnitPositions[i];
                    mTempVector2.X += SCROLLING_SPEED;
                    mPlacedUnitPositions[i] = mTempVector2;
                }
                for (int i = 0; i < mPlacedObstaclePositions.Count; i++)
                {
                    mTempVector2 = mPlacedObstaclePositions[i];
                    mTempVector2.X += SCROLLING_SPEED;
                    mPlacedObstaclePositions[i] = mTempVector2;
                }
            }

            SCROLLING_SPEED = SCROLL_SPEED_BASE;

            if (Keyboard.GetState().IsKeyDown(Keys.Enter) == true)
            {
                outputToFile();
                return false;
            }
            return true;
        }

        private bool containsMousePoint(Vector2 tilePosition)
        {
            if (tilePosition.X <= Mouse.GetState().X && tilePosition.Y <= Mouse.GetState().Y && tilePosition.X + mTileSize > Mouse.GetState().X && tilePosition.Y + mTileSize > Mouse.GetState().Y)
                return true;
            else
                return false;

        }
    }
}
