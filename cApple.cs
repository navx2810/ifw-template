using UnityEngine;
using System.Collections;
using Vexe.Runtime.Types;
using System.Collections.Generic;

namespace cApple
{
    public class Character : BetterBehaviour
    {
        private Data _FreshGameData;

        [Default("apple")]
        public string ID { get; set; }

        //[Inline, OnChanged("CheckNull")]
        [Inline]
        public Data GameData { get; set; }


        public Data FreshGameData
        {
            get
            {
                if (_FreshGameData == null)
                    _FreshGameData = ScriptableObject.CreateInstance<Data>();

                return _FreshGameData;
            }
        }

    }

    public class Data : BetterScriptableObject
    {
        #region Attributes
        [Paragraph] public string Nickname { get; set; }
        public int Description { get; set; }
        #endregion

        #region Unity Editor Logic
        [UnityEditor.MenuItem("Idler/Test Me")]
        static void CreateAsset()
        {
            var scriptable_object = CreateInstance<cApple.Data>();

            UnityEditor.AssetDatabase.CreateAsset(scriptable_object, "Assets/apple.asset");
        }
        #endregion

        #region Setting Default Values
        [Show]
        protected void SetDefaults()
        {
            ID = "apple"
            
            Nickname = "carrrl"
            Description = 50
    
            #region Curves
            Curves[0] = new Level { Damage = 40, Cost = 200 }
            Curves[1] = new Level { Damage = 90, Cost = 500 }
            Curves[2] = new Level { Damage = 150, Cost = 1000 }
            #endregion
        }
        #endregion

        #region Helpers
        public Data WithDefaults()
        {
            SetDefaults();
            return this;
        }
        #endregion
    }
}

