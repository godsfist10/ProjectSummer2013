 using System;
using System.Collections.Generic;
using System.Linq;
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

    public class Game1 : Microsoft.Xna.Framework.Game
    {
        GraphicsDeviceManager graphics;
        SpriteBatch spriteBatch;
      
        MapEditor mapEditor;
        
        const int SCREENHEIGHT = 720;
        const int SCREENWIDTH = 1280;
      
        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            graphics.PreferredBackBufferHeight = SCREENHEIGHT;
            graphics.PreferredBackBufferWidth = SCREENWIDTH;
            Content.RootDirectory = "Content";
        }

        protected override void Initialize()
        {   
            mapEditor = new MapEditor();
            IsMouseVisible = true;
            base.Initialize();
            
        }

        protected override void LoadContent()
        {           
            spriteBatch = new SpriteBatch(GraphicsDevice);
            mapEditor.loadContent(Content);
            Initialize2();
        }

        protected void Initialize2()
        {
            mapEditor.init();
        }

        protected override void UnloadContent()
        {
        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed)
                this.Exit();
            if (!mapEditor.update())
                this.Exit();
            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.CornflowerBlue);          
            spriteBatch.Begin();
            mapEditor.draw(spriteBatch);
            spriteBatch.End();
            base.Draw(gameTime);
        }
    }
}
